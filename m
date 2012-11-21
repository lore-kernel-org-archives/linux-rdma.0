From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: srp-ha backport
Date: Wed, 21 Nov 2012 15:31:12 +0100
Message-ID: <50ACE5B0.3060607@acm.org>
References: <5054492E.1090403@acm.org> <loom.20121120T050107-224@post.gmane.org> <50AB84C1.5090105@acm.org> <CACaajQtEu_z+GEUBuiDz6D1dHYsb-YSFMJfkWeya1FNvfhbQHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQtEu_z+GEUBuiDz6D1dHYsb-YSFMJfkWeya1FNvfhbQHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Vasiliy,

You should already get reasonable behavior with the default settings of 
all these timeout parameters. How long had you been waiting for 
multipath -ll before giving up ?

Bart.

On 11/21/12 15:26, Vasiliy Tolstov wrote:
> Hmm. Ok What timeouts i need to set to correct fail devices?
> For example i have timeout on each sd* device in
> /sys/block/sd*/device/timeout
> fast_io_fail_tmo and dev_loss_tmo in multipath and dev_loss_tmo
> fast_io_fail_tmo in ib_srp...
> Does timeout on sd* device need to be smaller that srp timeouts and
> multipath? Does multipaths timeouts must be equal of srp timeouts?
>
>
> 2012/11/20 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org <mailto:bvanassche-HInyCGIudOg@public.gmane.org>>
>
>     On 11/20/12 05:04, Vasiliy Tolstov wrote:
>
>         Thanks for this backport! I have some problem under sles 11 sp2
>         (kernel 3.0.42-
>         0.7-xen) then i shutdown srp target (reboot one sas server)
>         multipath -ll does
>         not respond. If i provide in multipath and srp identical
>         dev_loss_tmo and
>         fast_io_fail_tmo nothing changed. multipath -ll unblocks only
>         then the server
>         goes up.
>
>
>     That's strange. After the fast_io_fail_tmo timer has fired multipath
>     -ll should unblock independent of the state of the SRP target.
>
>     Bart.
>
>
>
>
> --
> Vasiliy Tolstov,
> Clodo.ru
> e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org <mailto:v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
> jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org <mailto:vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
