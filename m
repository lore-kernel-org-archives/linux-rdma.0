From: "Bob Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: libverbs version confusion
Date: Thu, 21 Oct 2010 13:19:39 -0500
Message-ID: <002101cb714c$868c83c0$93a58b40$@systemfabricworks.com>
References: <000001cb70e5$53755050$fa5ff0f0$@systemfabricworks.com> <20101021164812.GD30648@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101021164812.GD30648-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks Jason,

That fixed it.

Bob

-----Original Message-----
From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org] 
Sent: Thursday, October 21, 2010 11:48 AM
To: Bob Pearson
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: libverbs version confusion

On Thu, Oct 21, 2010 at 01:00:55AM -0500, Bob Pearson wrote:
> I have an application that links to -libverbs (1.5.2) and for some 
> reason ibv_open_device goes to the compat 1.0 version not the default 
> one. Other apps in the same development tree and the standard ones 
> like ib_send_bw all link to __ibv_open_device which is the default on 
> the same system. Who or what decides which version of the symbol get 
> linked? I have looked everywhere and haven't found a clue yet. [BTW 
> the calls to libibverbs are in a shared application library that is itself
linked into the application.
> That library has no versioning. I compared to librdmacm which also 
> depends on libibverbs but there was nothing there mentioning the 
> version of the libibverbs api.]

This was brought up not too long ago.

Everything that links to ibverbs must do so explicitly. Run ldd on your
shared library and it is probably missing a dependency on verbs. You have to
add -libverbs when linking shared libraries.

Shared libraries should always explicitly link to their requried libraries
rather than relying on the app to link. Otherwise symbol versions don't
work.

> It turns out that __ibv_open_device_1_0 returns a context struct that 
> sort of looks the same except that the cmd_fd is left uninitialized 
> but the version 1.1 context is passed as real_ctx. Subsequent calls to 
> ibv_xxx fail because the cmd_fd is uninitialized and has a random 
> (large) value. Is someone else supposed to fill in the rest of the 
> fields in the 1.0 version of the ibv_context?

Yes, the scheme that was used for symbol versions only works for very simple
cases, the v1.0 compat calls return structure pointers that are not
compatble with the v1.1 calls. Plus, you are compiling with the
v1.1 header and linking to the v1.0 compat calls, so you are extra broken :)

Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
