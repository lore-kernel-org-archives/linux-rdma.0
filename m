From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: Issues with starting srp_daemon userspace for a 4.13 kernel
Date: Tue, 18 Jul 2017 20:05:34 +0000
Message-ID: <1500408333.2664.6.camel@wdc.com>
References: <b74ff7c3-734b-71ae-6b67-9a8ccf255bf6@redhat.com>
         <20170718194846.GA6048@obsidianresearch.com>
         <ef6d29a5-9632-bd9b-1113-1de6671031cc@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ef6d29a5-9632-bd9b-1113-1de6671031cc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <4F9580210A89634FB5A224AEFC669C6D-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-07-18 at 16:01 -0400, Laurence Oberman wrote:
> Yep, That patch seems to be in 4.12 and in 4.13 RC1.
> 4.12 is working.
> I am going to add some debug now as I really dont feel like a bisect=20
> build unless I first try figure out the differences.

Hello Laurence,

Is SELinux enabled on your test setup? If so, can you repeat your test
after having disabled it?

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
