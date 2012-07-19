From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 3/5] IB/qib: Add support for per-device/per-port parameters
Date: Thu, 19 Jul 2012 11:26:43 -0700
Message-ID: <CAL1RGDVb964pLxx=gvuvP5SWcXT2+g2pPssH6YRSq0LFhup7yA@mail.gmail.com>
References: <20120719130356.4706.63775.stgit@kop-dev-sles11-04.qlogic.org> <20120719130411.4706.88736.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120719130411.4706.88736.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

[resending because I forgot to cc linux-rdma]

On Thu, Jul 19, 2012 at 6:04 AM, Mike Marciniszyn
<mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Add support for per-device/per-port driver parameters
> allowing users to specify different values for different
> ports/devices. All converted parameters will behave as
> expected if the old parameter format is used.
>
> New per-device/per-port parameter format:
>     <param>=[<d>,]<u>[:<p>]=<v>[,<u>[:<p>]=<v>]
> where:
>     <param> - driver parameter name
>     <d> - default value applicable to all devices/ports
>     <u> - unit number (zero-based)
>     <p> - port number (1-based)
>     <v> - numeric value

I think this is pushing the module parameter facility way past the
breaking point of usability.  We really need to come up with a better
way to get complex structured config info like this into the drive
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
