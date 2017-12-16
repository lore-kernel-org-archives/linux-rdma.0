From: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Support for generalized use of make C={1,2} via
 a wrapper program
Date: Sat, 16 Dec 2017 09:47:45 -0800
Message-ID: <20171216094745.5e41ac51@xeon-e3>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolas Palix <nicolas.palix-wMUr/XMoy4A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cocci-/FJkirnvOdkvYVN+rsErww@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Marek <michal.lkml-yyZNWGI4GtDR7s880joybQ@public.gmane.org>, Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>, John Haxby <john.haxby-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?w4VzbXVuZCDDmHN0dm9sZA==?= <asmund.ostvold-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Kees Cook <keesc>
List-Id: linux-rdma@vger.kernel.org

On Sat, 16 Dec 2017 15:42:25 +0100
Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> This patch series implements features to make it easier to run checkers on the
> entire kernel as part of automatic and developer testing.
> 
> This is done by replacing the sparse specific setup for the C={1,2} variable
> in the makefiles with setup for running scripts/runchecks, a new program that
> can run any number of different "checkers". The behaviour of runchecks is
> defined by simple "global" configuration in scripts/runchecks.cfg which can be
> extended by local configuration applying to individual files, directories or
> subtrees in the source.
> 
> It also fixes a minor issue with "checkpatch --fix-inplace" found during testing
> (patch #3).
> 
> The runchecks.cfg files are parsed according to this minimal language:
> 
>        # comments
>        # "Global configuration in scripts/runchecks.cfg:
>        checker <name>
>        typedef NAME regex
>        run <list of checkers or "all"
> 
>        # "local" configuration:
>        line_len <n>
>        except checkpatch_type [files ...]
>        pervasive checkpatch_type1 [checkpatch_type2 ...]
> 
> With "make C=2" runchecks first parse the file scripts/runchecks.cfg, then
> look for a file named 'runchecks.cfg' in the same directory as the source file.
> If that file exists, it will be parsed and it's local configuration applied to
> allow suppression on a per checker, per check and per file basis.
> If a "local" configuration does not exist, either in the source directory or
> above, make will simply silently ignore the file.
> 
> The idea is that the community can work to add runchecks.cfg files to
> directories, serving both as documentation and as a way for subsystem
> maintainers to enforce policies and individual tastes as well as TODOs and/or
> priorities, to make it easier for newcomers to contribute in this area. By
> ignoring directories/subtrees without such files, automation can start right
> away as it is trivially possible to run errorless with C=2 for the entire
> kernel.
> 
> For the checker maintainers this should be a benefit as well: new
> or improved checks would generate new errors/warnings. With automatic testing
> for the checkers, these new checks would generate error reports and cause
> builds to fail. Adding the new check a 'pervasive' option at the top level or
> even for specific files, marked with a "new check - please consider fixing" comment
> or similar would make those builds pass while documenting and making the new check
> more visible.
> 
> The patches includes a documentation file with some more details.
> 
> This patch set has evolved from an earlier shell script implementation I made
> as only a wrapper script around checkpatch. That version have been used for a
> number of years on a driver project I worked on where we had automatic checkin
> regression testing. I extended that to also run checkpatch to avoid having to
> clean up frequent unintended whitespace changes and style violations from others...
> 
> I have also tested this version on some directories I am familiar with.  The
> result of that work is available in two patch sets of 10 and 11 patches, but we
> agreed that it would be better to post them as separate patch sets later.
> 
> Those patch sets illustrates how I picture the "flow" from just "reining in" the
> checkpatch detections to actually fixing classes of checkpatch issues one by
> one, while updating the checkpatch.cfg file(s) to have 0 errors or warnings at
> any commit boundary.
> 
> The combined set is available here:
> 
>    git://github.com/knuto/linux.git  branch runchecks
> 
> I only include version 0 of runchecks.cfg in the two directories I
> worked on here as the final two patches. These files both documents where
> the issues are in those two directories, and can be used by the maintainer
> to indicate to potential helpers what to focus on as I have tried to
> illustrate by means of comments.
> 
> Changes from v1:
> -----------------
> Based on feedback, the implementation is completely rewritten and extended.
> Instead of patches to checkpatch, and a sole checkpatch focus, it is now a
> generic solution implemented in python, for any type of checkers, extendable
> through some basic generic functionality, and for special needs by subclassing
> the Checker class in the implementation.
> 
> This implementation fully supports checkpatch, sparse and
> checkdoc == kernel-doc -none, and also has been tested with coccicheck.
> To facilitate the same mechanism of using check types to filter what
> checks to be suppressed, I introduced the concept of "typedefs" which allows
> runchecks to effectively augment the check type space of the checker in cases
> where types either are not available at all (checkdoc) or where only a few
> can be filtered out (sparse)
> 
> With this in place it also became trivial to make the look and feel similar
> for sparse and checkdoc as for checkpatch, with some optional color support
> too, to make fixing issues in the code, the goal of this whole exercise,
> much more pleasant IMHO :-)
> 
> Thanks,
> Knut
> 
> Knut Omang (5):
>   runchecks: Generalize make C={1,2} to support multiple checkers
>   Documentation: Add doc for runchecks, a checker runner
>   checkpatch: Improve --fix-inplace for TABSTOP
>   rds: Add runchecks.cfg for net/rds
>   RDMA/core: Add runchecks.cfg for drivers/infiniband/core
> 
>  Documentation/dev-tools/coccinelle.rst |  12 +-
>  Documentation/dev-tools/index.rst      |   1 +-
>  Documentation/dev-tools/runchecks.rst  | 215 ++++++++-
>  Documentation/dev-tools/sparse.rst     |  30 +-
>  Documentation/kbuild/kbuild.txt        |   9 +-
>  Makefile                               |  23 +-
>  drivers/infiniband/core/runchecks.cfg  |  83 +++-
>  net/rds/runchecks.cfg                  |  76 +++-
>  scripts/Makefile.build                 |   4 +-
>  scripts/checkpatch.pl                  |   2 +-
>  scripts/runchecks                      | 734 ++++++++++++++++++++++++++-
>  scripts/runchecks.cfg                  |  63 ++-
>  scripts/runchecks_help.txt             |  43 ++-
>  13 files changed, 1274 insertions(+), 21 deletions(-)
>  create mode 100644 Documentation/dev-tools/runchecks.rst
>  create mode 100644 drivers/infiniband/core/runchecks.cfg
>  create mode 100644 net/rds/runchecks.cfg
>  create mode 100755 scripts/runchecks
>  create mode 100644 scripts/runchecks.cfg
>  create mode 100644 scripts/runchecks_help.txt
> 
> base-commit: ae64f9bd1d3621b5e60d7363bc20afb46aede215

I like the ability to add more checkers and keep then in the main
upstream tree. But adding overrides for specific subsystems goes against
the policy that all subsystems should be treated equally.

There was discussion at Kernel Summit about how the different
subsystems already have different rules. This appears to be a
way to make that worse.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
