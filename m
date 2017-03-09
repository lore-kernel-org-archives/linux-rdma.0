From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: libacm fails to build
Date: Thu, 9 Mar 2017 10:10:14 -0700
Message-ID: <20170309171014.GC12694@obsidianresearch.com>
References: <20170309102527.3ni4pkuendwzqzrm@paradies.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170309102527.3ni4pkuendwzqzrm-TXhXIaCUHZEYitT5tn2FcQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Philipp Thomas <pth-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 09, 2017 at 11:25:27AM +0100, Philipp Thomas wrote:

> I'm trying to build latest rdma-core but it fails in ibacm because a
> library is missing:

The suse cmake rpm macros are broken, this is worked around in the
shipped rdma-core.spec:

# Tumbleweed's cmake RPM macro adds -Wl,--no-undefined to the module flags
# which is totally inappropriate and breaks building 'ENABLE_EXPORTS' style
# module libraries (eg ibacmp).
%define CMAKE_FLAGS -DCMAKE_MODULE_LINKER_FLAGS=""

Ideally you would consult internally to globally fix the rpm cmake
macro, otherwise you have to use the above hack..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
