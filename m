From: "Bob Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: libverbs version confusion
Date: Thu, 21 Oct 2010 01:00:55 -0500
Message-ID: <000001cb70e5$53755050$fa5ff0f0$@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I have an application that links to -libverbs (1.5.2) and for some reason
ibv_open_device goes to the compat 1.0 version not the default one. Other
apps in the same development tree and the standard ones like ib_send_bw all
link to __ibv_open_device which is the default on the same system. Who or
what decides which version of the symbol get linked? I have looked
everywhere and haven't found a clue yet. [BTW the calls to libibverbs are in
a shared application library that is itself linked into the application.
That library has no versioning. I compared to librdmacm which also depends
on libibverbs but there was nothing there mentioning the version of the
libibverbs api.]

It turns out that __ibv_open_device_1_0 returns a context struct that sort
of looks the same except that the cmd_fd is left uninitialized but the
version 1.1 context is passed as real_ctx. Subsequent calls to ibv_xxx fail
because the cmd_fd is uninitialized and has a random (large) value. Is
someone else supposed to fill in the rest of the fields in the 1.0 version
of the ibv_context?

Bob

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
