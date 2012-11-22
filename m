From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: srp-ha backport
Date: Thu, 22 Nov 2012 08:36:55 +0100
Message-ID: <50ADD617.80500@acm.org>
References: <5054492E.1090403@acm.org> <loom.20121120T050107-224@post.gmane.org> <50AB84C1.5090105@acm.org> <CACaajQtEu_z+GEUBuiDz6D1dHYsb-YSFMJfkWeya1FNvfhbQHg@mail.gmail.com> <50ACE5B0.3060607@acm.org> <CACaajQsUR92Hg-nx_VQN1eHdnghDtsRv1xZJFaJKT=a4nWWf8Q@mail.gmail.com> <CACaajQswh5foLKTGMhbZnj5JRpFax7nhdHxL7c1wTwbpMe=b8A@mail.gmail.com> <50AD1EE6.6090206@acm.org> <CACaajQs3pPpB9Bz1OxRduk63+uu+ahBYYZsYv_VgroWCsr+vzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQs3pPpB9Bz1OxRduk63+uu+ahBYYZsYv_VgroWCsr+vzQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Vasily,

Replacing the kernel on the initiator system is sufficient. You don't=20
have to replace the kernel on the target system for this test. Regardin=
g=20
which InfiniBand stack to use at the initiator side in combination with=
=20
kernel 3.6: unless there is something I do not yet know about, it is=20
fine to use the InfiniBand stack included in that kernel and it is not=20
necessary to install OFED for this test.

Bart.

On 11/21/12 20:52, Vasiliy Tolstov wrote:
> Does i need that on storage host side or on onitiator side? My storag=
e
> under debian squeeze with ofed from openfabrics.
>
> 21.11.2012 22:35 =D0=BF=D0=BE=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=
=D0=B5=D0=BB=D1=8C "Bart Van Assche" <bvanassche-HInyCGIudOg@public.gmane.org
> <mailto:bvanassche-HInyCGIudOg@public.gmane.org>> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB=
:
>
>     On 11/21/12 18:41, Vasiliy Tolstov wrote:
>
>         Another test has very bad results:
>         initiator multipath -ll running than storage go to down never
>         returns
>         (deadlock), but other multipath -ll returns immediate with
>         output (i'm
>         reboot sas01)
>
>
>     It could be helpful to have a look at the call stacks generated b=
y
>     "echo w >/proc/sysrq-trigger". If this output reveals that device
>     removal triggers hanging I/O then that might indicate that one or
>     more SCSI device removal patches have not yet been backported to
>     SLES 11 SP2. Have you already tried whether the same test succeed=
s
>     with kernel 3.6.7 ? Several SCSI device removal fixes have been
>     integrated in kernel 3.6.
>
>     Bart.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
