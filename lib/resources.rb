require "yajl/json_gem"

module Dribbble
  module Resources
    module Helpers
      STATUSES = {
        200 => "200 OK",
        201 => "201 Created",
        202 => "202 Accepted",
        204 => "204 No Content",
        205 => "205 Reset Content",
        301 => "301 Moved Permanently",
        302 => "302 Found",
        307 => "307 Temporary Redirect",
        304 => "304 Not Modified",
        401 => "401 Unauthorized",
        403 => "403 Forbidden",
        404 => "404 Not Found",
        405 => "405 Method not allowed",
        409 => "409 Conflict",
        422 => "422 Unprocessable Entity",
        500 => "500 Server Error",
        502 => "502 Bad Gateway"
      }

      USER = {
        id: 1,
        name: "Dan Cederholm",
        username: "simplebits",
        html_url: "https://dribbble.com/simplebits",
        avatar_url: "https://d13yacurqjgara.cloudfront.net/users/1/avatars/normal/dc.jpg?1371679243",
        bio: "Co-founder and designer of Dribbble. Principal of SimpleBits. Aspiring clawhammer banjoist.",
        location: "Salem, MA",
        links: {
          web: "http://simplebits.com",
          twitter: "https://twitter.com/simplebits"
        },
        followers_count: 29262,
        followings_count: 1728,
        likes_count: 34954,
        shots_count: 214,
        type: "User",
        created_at: "2009-07-08T02:51:22Z",
        updated_at: "2014-02-22T17:10:33Z"
      }

      TEAM = {
        id: 39,
        name: "Dribbble",
        username: "dribbble",
        html_url: "https://dribbble.com/dribbble",
        avatar_url: "https://d13yacurqjgara.cloudfront.net/users/39/avatars/normal/apple-flat-precomposed.png?1388527574",
        bio: "Show and tell for designers. This is Dribbble on Dribbble.",
        location: "Salem, MA",
        links: {
          web: "http://dribbble.com",
          twitter: "https://twitter.com/dribbble"
        },
        followers_count: 25011,
        followings_count: 6120,
        likes_count: 44,
        shots_count: 91,
        type: "Team",
        created_at: "2009-08-18T18:34:31Z",
        updated_at: "2014-02-14T22:32:11Z"
      }

      SHOT = {
        id: 471756,
        title: "Sasquatch",
        images: {
          hidpi: nil,
          normal: "https://d13yacurqjgara.cloudfront.net/users/1/screenshots/471756/sasquatch.png",
          teaser: "https://d13yacurqjgara.cloudfront.net/users/1/screenshots/471756/sasquatch_teaser.png"
        },
        views_count: 4372,
        likes_count: 149,
        comments_count: 27,
        attachments_count: 0,
        rebounds_count: 2,
        buckets_count: 8,
        created_at: "2012-03-15T01:52:33Z",
        updated_at: "2012-03-15T02:12:57Z",
        html_url: "https://dribbble.com/shots/471756-Sasquatch",
        comments_url: "https://api.dribbble.com/v1/shots/471756/comments",
        rebounds_url: "https://api.dribbble.com/v1/shots/471756/rebounds",
        tags: %w(fiction sasquatch sketch wip),
        user: USER,
        team: TEAM
      }

      REBOUND = {
        id: 472178,
        title: "Vector Victor",
        images: {
          hidpi: nil,
          normal: "https://d13yacurqjgara.cloudfront.net/users/1/screenshots/472178/vector-victor.png",
          teaser: "https://d13yacurqjgara.cloudfront.net/users/1/screenshots/472178/vector-victor_teaser.png"
        },
        views_count: 3555,
        likes_count: 62,
        comments_count: 6,
        attachments_count: 0,
        rebounds_count: 1,
        buckets_count: 1,
        created_at: "2012-03-15T12:53:33Z",
        updated_at: "2012-03-15T12:54:27Z",
        html_url: "https://dribbble.com/shots/472178-Vector-Victor",
        comments_url: "https://api.dribbble.com/v1/shots/472178/comments",
        rebounds_url: "https://api.dribbble.com/v1/shots/472178/rebounds",
        rebound_source_url: "https://api.dribbble.com/v1/shots/471756",
        tags: %w(photoshop sasquatch vector wip),
        user: USER,
        team: TEAM
      }

      COMMENT = {
        id: 3360155,
        body: "We're working on refining profiles, while paving the way for something we're calling \"Playbook\".",
        likes_count: 71,
        created_at: "2014-02-14T22:32:11Z",
        updated_at: "2014-02-14T22:32:11Z",
        user: USER
      }

      LIKE = {
        id: 4,
        created_at: "2009-07-23T10:17:39Z",
        screenshot: SHOT
      }

      def headers(status, headers = {})
        class_name = "headers"
        class_name << " no-response" if [204, 404].include?(status)

        lines = ["Status: #{STATUSES[status]}"]

        headers.each do |key, value|
          lines << "#{key}: #{value}"
        end

        lines << "X-RateLimit-Limit: 5000"     unless headers.has_key?("X-RateLimit-Limit")
        lines << "X-RateLimit-Remaining: 4999" unless headers.has_key?("X-RateLimit-Remaining")

        %(<pre class="#{class_name}"><code>#{lines * "\n"}</code></pre>\n)
      end

      def json(key)
        hash = if key.is_a?(Hash)
                 key.inject({}) do |result, (key, value)|
                   result[key.to_s] = value
                   result
                 end
               elsif key.is_a?(Array)
                 key
               else
                 Resources.const_get(key.to_s.upcase)
               end

        if block_given?
          hash = yield(hash)
        end

        %{<pre><code class="language-javascript">#{JSON.pretty_generate(hash).gsub('":', '" :')}</code></pre>}
      end
    end
  end
end

include Dribbble::Resources::Helpers
