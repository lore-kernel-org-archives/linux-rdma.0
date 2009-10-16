From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] opensm: add force_link_speed_file config option.
Date: Thu, 15 Oct 2009 17:23:43 -0700
Message-ID: <alpine.LFD.1.10.0910151722000.24802@topaz.mv.qlogic.com>
References: <20091015132650.6e8b8dde.weiny2@llnl.gov> <20091015212601.GK20210@me> <20091015170428.4e75735f.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091015170428.4e75735f.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 15 Oct 2009, Ira Weiny wrote:
| > And what about width and other potentially tunable port parameters?
| 
| I don't think width is "tunable" via the spec.  The force_link_speed option
| was a non-standard work around for potentially bad hardware.  I was trying to
| avoid going down the non-standard path too much.

There's infiniband hardware that can't do 1X, also.  Yes, it's
non-compliant, but it exists.

4X-only mode can be set (and reported correctly) by the tools as an extension
in the same manner as the speed extension, so it may as well be handled
the same way, if you are going to fix the one.

Dave Olson
dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
