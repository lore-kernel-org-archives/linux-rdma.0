From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: libacm fails to build
Date: Thu, 9 Mar 2017 16:54:06 -0700
Message-ID: <20170309235406.GA16385@obsidianresearch.com>
References: <20170309102527.3ni4pkuendwzqzrm@paradies.suse.de>
 <20170309171014.GC12694@obsidianresearch.com>
 <1489098918.2597.12.camel@sandisk.com>
 <20170309224904.GA5867@obsidianresearch.com>
 <1489099998.2597.16.camel@sandisk.com>
 <20170309230453.GA7844@obsidianresearch.com>
 <1489101151.2597.18.camel@sandisk.com>
 <20170309232352.GA12387@obsidianresearch.com>
 <1489103252.2597.20.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489103252.2597.20.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "pth-l3A5Bk7waGM@public.gmane.org" <pth-l3A5Bk7waGM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 09, 2017 at 11:47:46PM +0000, Bart Van Assche wrote:
> On Thu, 2017-03-09 at 16:23 -0700, Jason Gunthorpe wrote:
> > It seems like something else is going on with your system, I wonder if
> > your system could have a conflicting rpm macro?
> 
> That might be what's causing trouble ... both /etc/rpm/macros.kde4 and
> /etc/rpm/macros.qt5 contain the following definition:

Gurk. That seems like another suse bug :(

> %make_jobs %{__make} %{?_smp_mflags} VERBOSE=1
> 
> How about explicitly defining %make_jobs in the rdma-core spec to work
> around this?

Yes, I think so, like this?

diff --git a/rdma-core.spec b/rdma-core.spec
index 6519bc370a230a..df65745ff9c468 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -26,7 +26,9 @@ BuildRequires: valgrind-devel
 # SuSE releases have it, and sometime around cmake 3.3.2-1.2 the macros learned to use it.
 BuildRequires: ninja,make
 %define __builder ninja
-# cmake_install,make_jobs is specified by opensuse
+# cmake_install is specified by opensuse. It also specifies make_jobs, but it
+# doesn't work with __builder as other rpm macro packages define it too.
+%define make_jobs ninja-build -v %{?_smp_mflags}
 
 # Tumbleweed's cmake RPM macro adds -Wl,--no-undefined to the module flags
 # which is totally inappropriate and breaks building 'ENABLE_EXPORTS' style
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
