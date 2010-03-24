From: Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ibstat stuck in state initialized after reboot
Date: Wed, 24 Mar 2010 15:16:34 -0400
Message-ID: <c177de4a1003241216w162e3fn8bde336c62dd9edb@mail.gmail.com>
References: <E25E098F-AFCA-4FEA-BE46-5AF59C408293@mines.edu>
	 <20100324093805.4c7c1034.weiny2@llnl.gov>
	 <4256D4F9-36CC-4C21-A459-B69B363F29C9@mines.edu>
	 <6203933669E90E4AB42B5BC4EDE38D350C9B6386B6@orsmsx510.amr.corp.intel.com>
	 <230744DB-D7A7-4A1C-973E-E0D7097554DE@mines.edu>
	 <20100324112525.fc4a8eb9.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100324112525.fc4a8eb9.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Michael Robbert <mrobbert-/qOHPfZA4H6HXe+LvDLADg@public.gmane.org>, "Meyer, Donald J" <donald.j.meyer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 24, 2010 at 2:25 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> On Wed, 24 Mar 2010 11:34:02 -0600
> Michael Robbert <mrobbert-/qOHPfZA4H6HXe+LvDLADg@public.gmane.org> wrote:
>
> I will second this. =A0OpenSM has come a long way since the time Cisc=
o was
> selling IB switches. =A0If I understand your situation you don't even=
 need the
> 7000D you could just remove it and run OpenSM on a "management" node.=
 =A0If you
> can afford it adding a node for OpenSM would be nice but I am not sur=
e you
> _need_ it.
>
> OpenSM is now managing many of the largest IB networks out there, on =
a 288
> node system it will have no problems at all "out of the box".
>

Can you provide any guidelines to determine when a dedicated
management node is beneficial?

BTW, we also found that OpenSM is superior to to the SM embedded in
our switches.

Chuck
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
