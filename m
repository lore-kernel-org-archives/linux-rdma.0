From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
 infrastructure bits
Date: Wed, 19 Oct 2016 21:50:54 -0600
Message-ID: <20161020035054.GB28678@obsidianresearch.com>
References: <20161017162221.GI14983@redhat.com>
 <20161017174611.GB6430@obsidianresearch.com>
 <20161017182037.GK14983@redhat.com>
 <20161017185657.GA8122@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E24F0A408@CRSMSX101.amr.corp.intel.com>
 <20161017201309.GA24291@obsidianresearch.com>
 <20161018145104.GT14983@redhat.com>
 <2807E5FD2F6FDA4886F6618EAC48510E24F0DF57@CRSMSX101.amr.corp.intel.com>
 <20161019185920.GA20600@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E24F0E288@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E24F0E288-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2016 at 09:35:15PM +0000, Weiny, Ira wrote:

> set(rdma_ndd_CONFIG_PATH "${CMAKE_INSTALL_SYSCONFDIR}")
> configure_file ("${PROJECT_SOURCE_DIR}/rdma-ndd/rdma-config.h.in"
>         "${PROJECT_BINARY_DIR}/rdma-ndd/rdma-config.h")
> include_directories("${PROJECT_BINARY_DIR}/rdma-ndd")

Please just use the existing buildlib/config.h.in and put in:

#define RDMA_NDD_CONFIG_FILE "@CMAKE_INSTALL_FULL_SYSCONFDIR@/rdma-ndd.conf"

Nothing else is needed, please don't add more config.h's.

> #define RDMA_NDD_CONFIG_PATH "etc"

This is the difference between the 'FULL' and normal path versions in
the cmake scheme. The FULL version must be used everyplace needing an
absolute path, the other verions are used with install and have to do
with making DESTDIR work properly.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
