From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] cbuild: use rpmspec for macro replacement
Date: Wed, 9 Aug 2017 11:56:47 +0200
Message-ID: <b3993b0c-0b9d-a917-cbf8-22f68c1d2a97@suse.de>
References: <27366048-d80f-3711-c6cd-93c87809650e@suse.de>
 <8ad0438f-b4a5-aec9-1e44-a9c9dc1ca17b@suse.de>
 <20170808230459.GF29372@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170808230459.GF29372-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 09/08/2017 à 01:04, Jason Gunthorpe a écrit :
> On Fri, Aug 04, 2017 at 06:59:10PM +0200, Nicolas Morey-Chaisemartin wrote:
>> Generate a temporary file with the spec file parsed and all its macro replaced.
>> Avoid manually replacing Version and handle extra macros
>>
>> Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
>>  .gitignore      | 3 +++
>>  buildlib/cbuild | 8 ++++++--
>>  2 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/.gitignore b/.gitignore
>> index f31a0617..52c7af2f 100644
>> +++ b/.gitignore
>> @@ -69,3 +69,6 @@ tramp
>>  Session.vim
>>  .netrwhist
>>  *~
>> +
>> +# rpm
>> +*/*.spec.processed
>> \ No newline at end of file
>> diff --git a/buildlib/cbuild b/buildlib/cbuild
>> index 5228ec1b..cf7828eb 100755
>> +++ b/buildlib/cbuild
>> @@ -404,7 +404,12 @@ def get_image_id(args,image_name):
>>  
>>  def run_rpm_build(args,spec_file,env):
>>      version = get_version();
>> -    with open(spec_file,"r") as F:
>> +
>> +    # Pre-process file with rpm spec to avoid manually replacing macros
>> +    f = open(spec_file + ".processed", "w");
>> +    subprocess.check_call(["rpmspec", "-P", spec_file], stdout=f);
> This isn't going to work on any host system that does not have
> rpmspec, including my Debian systems..
Are you building RPM outside of docker on your Debian ?
I ran the pkg suite for all targets and they all work.
rpmspec is with RPM since v4.9.0 which came out in early 2011 so it should work with all current RPM -based distro

> How about something like this instead for the two patches?
>
> From 13e239b5fc39fff9e56760969b99eab462db3d89 Mon Sep 17 00:00:00 2001
> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Date: Tue, 8 Aug 2017 17:04:06 -0600
> Subject: [PATCH] cbuild: Be more robust when computing path names
>
> Always use the same format for the git archvie prefix, this matches
> the format that github-release uses, and is what a .spec file must work
> with.
>
> Use rpmspec -P to determine what the expected tar file name is instead of
> trying to do substitution internally.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  buildlib/cbuild | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/buildlib/cbuild b/buildlib/cbuild
> index 9b49fa5343c8b4..a3cf26e85bc722 100755
> --- a/buildlib/cbuild
> +++ b/buildlib/cbuild
> @@ -409,16 +409,10 @@ def get_image_id(args,image_name):
>  # -------------------------------------------------------------------------
>  
>  def run_rpm_build(args,spec_file,env):
> -    version = get_version();
>      with open(spec_file,"r") as F:
>          for ln in F:
> -            if ln.startswith("Version:"):
> -                ver = ln.strip().partition(' ')[2];
> -                assert(ver == get_version());
> -
You are losing this last check which seems important. It make sure the ti tag is in sync with the RPM

>              if ln.startswith("Source:"):
>                  tarfn = ln.strip().partition(' ')[2];
> -    tarfn = tarfn.replace("%{version}",version);
>  
>      image_id = get_image_id(args,env.image_name());
>      with private_tmp(args) as tmpdir:
> @@ -426,7 +420,8 @@ def run_rpm_build(args,spec_file,env):
>          os.mkdir(os.path.join(tmpdir,"tmp"));
>  
>          subprocess.check_call(["git","archive",
> -                               "--prefix","%s/"%(os.path.splitext(tarfn)[0]),
> +                               # This must match the prefix generated buildlib/github-release
> +                               "--prefix","%s-%s/"%(project,get_version()),
>                                 "--output",os.path.join(tmpdir,"SOURCES",tarfn),
You have an issue here because tarfn is not set yet.
I'm confused on why moving the call to rpmspec further down would solve your Debian issue ?

>                                 "HEAD"]);
>  
> @@ -453,17 +448,25 @@ def run_rpm_build(args,spec_file,env):
>          # for the user we are going to use to do the build.
>          with open(os.path.join(tmpdir,"go.py"),"w") as F:
>              print >> F,"""
> -import os;
> +import os,subprocess;
>  with open("/etc/passwd","a") as F:
>     print >> F, {passwd!r};
>  with open("/etc/group","a") as F:
>     print >> F, {group!r};
>  os.setgid({gid:d});
>  os.setuid({uid:d});
> +
> +# Get RPM to tell us the expected tar filename.
> +for ln in subprocess.check_output(["rpmspec","-P",{tspec_file!r}]).splitlines():
> +   if ln.startswith("Source:"):
> +      tarfn = ln.strip().partition(' ')[2];
> +os.symlink({tarfn!r},os.path.join("SOURCES",tarfn));
>  """.format(passwd=":".join(str(I) for I in pwd.getpwuid(os.getuid())),
>             group=":".join(str(I) for I in grp.getgrgid(os.getgid())),
>             uid=os.getuid(),
> -           gid=os.getgid());
> +           gid=os.getgid(),
> +           tarfn=tarfn,
> +           tspec_file=tspec_file);
>  
>              bopts = ["-bb",tspec_file];
>  


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
