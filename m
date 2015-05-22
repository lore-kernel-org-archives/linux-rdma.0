From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] libibverbs init.c: conditionally emit warning if no
 userspace driver found
Date: Fri, 22 May 2015 13:58:07 +0000
Message-ID: <B397943B-9919-47CC-94E9-98A2A0BEFE8F@cisco.com>
References: <1431440068-19037-1-git-send-email-jsquyres@cisco.com>
 <BED0001D-0051-4ACD-8506-8FA07E625694@cisco.com>
 <1432044878.5304.1.camel@opteya.com> <1432049804.3114.41.camel@redhat.com>
 <1432133301.5304.10.camel@opteya.com> <1432139226.3114.83.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FDD9BC@ORSMSX109.amr.corp.intel.com>
 <1432141870.3114.89.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432141870.3114.89.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <274B6C24C8F1E047AB3267BF0A691848-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On May 20, 2015, at 1:11 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> The location of the upstream sources and tarballs would not change.
> Neither the git repo nor the tarball repo were like the kernel.  The
> upstream kernel.org git repo Roland had, had his name in the repo.  So
> it had to change.  But the libibverbs repo is in a generic location.
> There is no need to change it, only to change the permissions on the git
> repo to allow the new maintainer to push directly into it.  

Did that happen yet?

> Ditto with
> the upload/download space on openfabrics.org/downloads/verbs.

It looks like someone did part of this on flatbed -- you own the download directory but none of the files, and they are all 644.  So I took the liberty of chown'ing them all to you:

----
$ hostname; pwd; ls -la
flatbed.openfabrics.org
/var/www/html/downloads/verbs
total 6096
drwxr-xr-x.  2 dledford ofed   4096 May  7  2014 .
drwxrwxr-x. 55 apache   ofed   4096 Feb 13 07:31 ..
-rw-r--r--.  1 dledford ofed 347508 Mar 14  2006 libibverbs-1.0.2.tar.gz
-rw-r--r--.  1 dledford ofed 349439 May  2  2006 libibverbs-1.0.3.tar.gz
-rw-r--r--.  1 dledford ofed 360410 Oct 31  2006 libibverbs-1.0.4.tar.gz
-rw-r--r--.  1 dledford ofed 359902 Jun 18  2007 libibverbs-1.0.5.tar.gz
-rw-r--r--.  1 dledford ofed 321835 Aug 29  2005 libibverbs-1.0-rc1.tar.gz
-rw-r--r--.  1 dledford ofed 338537 Oct  2  2005 libibverbs-1.0-rc3.tar.gz
-rw-r--r--.  1 dledford ofed 341792 Oct 28  2005 libibverbs-1.0-rc4.tar.gz
-rw-r--r--.  1 dledford ofed 347699 Feb 17  2006 libibverbs-1.0-rc7.tar.gz
-rw-r--r--.  1 dledford ofed 384743 Jun 18  2007 libibverbs-1.1.1.tar.gz
-rw-r--r--.  1 dledford ofed 394618 Apr 18  2008 libibverbs-1.1.2.tar.gz
-rw-r--r--.  1 dledford ofed 359331 Oct 29  2009 libibverbs-1.1.3.tar.gz
-rw-r--r--.  1 dledford ofed 362475 Jun  3  2010 libibverbs-1.1.4.tar.gz
-rw-r--r--.  1 dledford ofed 364219 Jun 28  2011 libibverbs-1.1.5.tar.gz
-rw-r--r--.  1 dledford ofed 387794 Dec 21  2011 libibverbs-1.1.6.tar.gz
-rw-r--r--.  1 dledford ofed 391812 May 28  2013 libibverbs-1.1.7.tar.gz
-rw-r--r--   1 dledford ofed 406548 May  5  2014 libibverbs-1.1.8.tar.gz
-rw-r--r--.  1 dledford ofed 384656 Apr 24  2007 libibverbs-1.1.tar.gz
-rw-r--r--   1 dledford ofed   3957 May  7  2014 README.html
-rw-r--r--.  1 dledford ofed     60 Mar 12  2008 WEB_README
-----

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
