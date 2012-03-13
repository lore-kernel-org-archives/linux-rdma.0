From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH/RFC] mxl4_core: Scale size of MTT table with system RAM
Date: Tue, 13 Mar 2012 10:59:33 -0700
Message-ID: <CAL1RGDVG7V8Mdh-PYJB7KGnFUmge0tPVU+CWK0W_Xm6Hd3EX5A@mail.gmail.com>
References: <1330970972-10225-1-git-send-email-roland@kernel.org>
 <CAJZOPZ+qLzZaH=fmKVRE0K559DoeQ1SsrsjSDY0TS-z8+WjnYQ@mail.gmail.com>
 <CAL1RGDVaGpVXukyKpJ2vPZE3br4UWn+td8Ba03fKHuY-53H2vg@mail.gmail.com> <4F5EE8CD.7020909@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F5EE8CD.7020909-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 12, 2012 at 11:27 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> If an app registered essentially all memory, then practically nothing else
> left for other users, or you refer to the case where the driver consumed an
> MTT segment made of 8 elements on behalf of a certain app but didn't use all
> the MTT entries of that segment?

Yeah, if we register a lot of small buffers we might waste a lot of MTTs.  Also
I was thinking that a multi-threaded app might might register
overlapping regions.

Thinking about it more, I wonder if we'll be able to allocate enough contiguous
memory for the buddy bitmaps on really big memory systems.  This might
force us to improve the buddy allocator so it doesn't rely on contiguous
bitmaps...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
