From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: How to build SDP module
Date: Mon, 25 Apr 2011 10:37:44 +0200
Message-ID: <BANLkTimvcwW-ev9AyDuNWSSrw8Xa8-o8+w@mail.gmail.com>
References: <BANLkTikDGaucXzqN8+uotCbqLE+UFW_Djw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikDGaucXzqN8+uotCbqLE+UFW_Djw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bhavinkumar thumar <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 25, 2011 at 10:12 AM, bhavinkumar thumar
<bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> OFED 1.5.2 has already been installed in my system and now I want to
> build and install the sdp module of OFED after making some change in
> it.
>
> I tried 'configure' script in /usr/src/ofa_kernel-1.5.2/ and then gave
> 'make' and 'make install' with required parameters. Then when I am
> trying to load the ib_sdp module it gives me following error:
>
> FATAL: Error inserting ib_sdp
> (/lib/modules/2.6.18-194.el5/updates/kernel/drivers/infiniband/ulp/sdp/ib_sdp.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
>
> I checked dmesg, it shows:
>
> ib_sdp: disagrees about version of symbol ib_unregister_client
> ib_sdp: Unknown symbol ib_unregister_client

That means that there is a conflict between the distro-provided IB
drivers and those provided by the OFED kernel RPM. Removing the
kernel/drivers/infiniband and kernel/drivers/net/mlx4 directories and
rebuilding OFED should be sufficient to fix this.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
