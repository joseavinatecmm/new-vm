#ifndef PATTERN_HPP
#define PATTERN_HPP

#include <string>

class Pattern {
private:
    std::string pattern;

public:
    Pattern(const std::string& p);
    ~Pattern();

    void setPattern(const std::string& p);
    std::string getPattern() const;
};

#endif
