From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/5] travis: Add RedHat and SuSE rpmbuild
 support
Date: Thu, 2 Nov 2017 11:31:23 -0600
Message-ID: <20171102173123.GQ18874@ziepe.ca>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102165556.22105-4-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 02, 2017 at 06:55:54PM +0200, Leon Romanovsky wrote:
> From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Provide a new script for testing rpmbuild under RedHat and SuSE
> environments which validates both of the suse/rdma-core.spec and
> redhat/rdma-core.spec specfiles.
> 
> The script performs the RPM package build test by utilizing the existing
> cbuild tool.

This breaks cbuild pkg travis - we should not attempt to build using
docker when run outside travis:

$ buildlib/cbuild pkg travis
[..]
+ for OS in centos7 opensuse-42.2 artful
+ echo
+ echo 'Checking package build for centos7 ....'
+ echo
+ buildlib/cbuild build-images centos7

Checking package build for centos7 ....

Traceback (most recent call last):
  File "buildlib/cbuild", line 54, in <module>
    import yaml
ImportError: No module named yaml
Traceback (most recent call last):
  File "buildlib/cbuild", line 802, in <module>
    args.func(args);
  File "buildlib/cbuild", line 631, in cmd_pkg
    run_travis_build(args,env);
  File "buildlib/cbuild", line 621, in run_travis_build
    docker_cmd(args,*opts);
  File "buildlib/cbuild", line 371, in docker_cmd
    return subprocess.check_call(["sudo","docker"] + cmd);
  File "/usr/lib/python2.7/subprocess.py", line 541, in check_call
    raise CalledProcessError(retcode, cmd)
subprocess.CalledProcessError: Command '['sudo', 'docker', 'run', '--read-only', '--rm=true', '-v', '/tmp/tmpxhYvXb:/home/travis/build', '-v', '/home/jgg/work/plumbing/.git:/home/travis/build/src/.git:ro', '-w', '/home/travis/build/src', '-u', '2009', '-e', 'TRAVIS_COMMIT_RANGE=41e755a28d97c1965f03b1c6ce6dd7b63def424d..HEAD', '-e', 'TRAVIS_BRANCH=41e755a28d97c1965f03b1c6ce6dd7b63def424d', '-e', 'TRAVIS_EVENT_TYPE=pull_request', '-e', 'HOME=/home/travis', '-e', 'TMPDIR=/home/travis/build/tmp', 'build-rdma-core/travis', '/bin/bash', '/home/travis/build/go.sh']' returned non-zero exit status 1

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
