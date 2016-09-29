From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core: cmake minimum version issue on RH 6.5
Date: Thu, 29 Sep 2016 10:46:53 -0600
Message-ID: <20160929164653.GC774@obsidianresearch.com>
References: <5169a490-10b4-cb9f-d7b7-fb552692f1f6@dev.mellanox.co.il>
 <57ED2E87.50008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57ED2E87.50008-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 29, 2016 at 11:08:55AM -0400, Doug Ledford wrote:
> On 9/29/16 7:40 AM, Yishai Hadas wrote:
> > Hi Jason,
> > 
> > Currently there is a hard requirement of cmake minimum version of 2.8.11
> > to build the rdma-core project. (i.e. cmake_minimum_required(VERSION
> > 2.8.11 ATAL_ERROR)).
> > 
> > 
> > Trying to build with default yum install of cmake on RH6.5 fails as it
> > doesn't meet the above requirement. (i.e. cmake version 2.6-patch 4).
> > 
> > As a test phase, we tried to comment out this limitation from the cmake
> > files, however, the build failed with few other errors. (e.g. CMake
> > Error at buildlib/rdma_functions.cmake:39 (set_property):
> > set_property could not find TARGET APPEND_STRING. Perhaps it has not yet
> > been created).
> > 
> > Is it a real requirement for above cmake minimum version in this project
> > ? if yes, where the appropriate cmake should come from to work on RH6.5.

> Is anyone really running 6.5?  I mean the current version in the 6
> family is 6.8, and there are significant improvements between 6.5 and 6.8.

Indeed, I did my testing on CentOS 6.8 and everything is fine. I
expect that RHEL6.8 has the same cmake version.

Simple Options:
- Upgrade to 6.8 and forget about 6.5, it is years old and deficient
  on security updates at this point?
- Do your build on 6.8, the resulting binary should still work on 6.5?
- Cherry pick the cmake RPM from 6.8 eg
   yum install  ftp://fr2.rpmfind.net/linux/centos/6.8/os/x86_64/Packages/cmake-2.8.12.2-4.el6.x86_64.rpm
- Use EPEL according to the README.md and install cmake3 from EPEL.
  I don't know if EPEL supports obsolete distros.
  
> > Is it a real requirement for above cmake minimum version in this project
> > ? if yes.

It is a real requirement, cmake has lots of tools to deal with changes
across versions so it could probably be relaxed, but I've tried to
keep everything simple so I'm not excited about a bunch more stuff to
support a 7 year old version of cmake.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
