From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core.spec and -DIN_PLACE
Date: Mon, 27 Mar 2017 16:44:39 -0600
Message-ID: <20170327224439.GA711@obsidianresearch.com>
References: <1490647788.7897.5.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1490647788.7897.5.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 27, 2017 at 08:50:01PM +0000, Bart Van Assche wrote:
> When I build an RPM using the top-level rdma-core.spec file I need the following
> patch to ensure that the verbs library looks into?/etc/libibverbs.d instead of a
> path in the build directory:

You certainly should not need something like this. I tried your script
in a tumbleweed container and it was fine...

Could something else in your envionrment be setting IN_PLACE?
Environment Variable? (Does rpmbuild not wipe those?) What does your
cmake line look like? Your script looks fine to me..

I added this to check, I didn't run anything..

diff --git a/CMakeLists.txt b/CMakeLists.txt
index da803443536925..33e0dad9868c70 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -51,6 +51,7 @@ set(PACKAGE_VERSION "13")
 
 # Override the CMAKE_INSTALL_ dirs to be under the build/ directory
 if (IN_PLACE)
+message(FATAL_ERROR "In place")
   set(CMAKE_INSTALL_SYSCONFDIR "${CMAKE_BINARY_DIR}/etc")
   set(CMAKE_INSTALL_BINDIR "${CMAKE_BINARY_DIR}/bin")
 endif()
diff --git a/rdma-core.spec b/rdma-core.spec
index 3f6e73a09ed12d..09c146f9324bd7 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -104,6 +104,7 @@ This is a simple example without the split sub packages to get things started.
 	 -DCMAKE_INSTALL_RUNDIR:PATH=%{_rundir} \
 	 -DCMAKE_INSTALL_DOCDIR:PATH=%{_docdir}/%{name}-%{version} \
 	 -DCMAKE_INSTALL_UDEV_RULESDIR:PATH=%{_udevrulesdir}
+cat include/config.h
 %make_jobs
 
 %install
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
