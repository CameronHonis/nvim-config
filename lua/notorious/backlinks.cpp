#include <string>
#include <vector>

using namespace std;

enum NoteType {
    SOURCE,
    CONCEPT,
    IDEA,
    QUESTION,
    ANSWER,
};

struct Backlink {
    string from;
    enum NoteType note_type;
    bool is_origin;
};

vector<Backlink> get_backlinks(string note_name) {
    return {{}, {}};
}
