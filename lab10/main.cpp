#include <iostream>
#include <sstream>
#include <string>
#include <fstream>
#include <pqxx/pqxx>
#include "lab10.h" 
 
using namespace std;
using namespace pqxx;

void sql_to_json(connection &conn, std::string query){
    std::string jsonQuery = "SELECT row_to_json(t) FROM (" + query + ") t";
    int iter = 0;
     try{
         work trsxn{conn};
         stateless_cursor<pqxx::cursor_base::read_only, pqxx::cursor_base::owned> json_cursor(trsxn, jsonQuery, "jsonCursor", false);
         result response;
         ofstream file("result.json");
         file << "[";
         
         do{
           response = json_cursor.retrieve(iter, iter + 1);
           iter++;
           for(result::const_iterator r : response){
               if(iter != 1){
                   file << ",";
               }
               file << r[0] << "\n";
           }
         }while(response.size() == 1);
         file << "]\n";
         file.close();
     }catch(const exception& e){
        cout << e.what() << endl;
     }
}
 
int main(int argc, char* argv[]) {
 
    stringstream ss;
    ss << "dbname = " << labdbname << " user = " << labdbuser << " password = " << labdbpass \
        << " host = " << labdbhost << " port = " << labdbport; 
    string s = ss.str();
 
    try {
        connection connlab(s);
        if (connlab.is_open()) {    
            cout << "Successfully connection to: " << connlab.dbname() << endl;
        } else {
            cout << "Problem with connection to database" << endl;
            return 1;
        }
        
        sql_to_json(connlab, "select * from lab_2.customer");
        
        connlab.disconnect ();
    } catch (const std::exception &e) {
        cerr << e.what() << std::endl;
        return 1;
    }
}