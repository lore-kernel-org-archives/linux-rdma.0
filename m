From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: error when compiling ofed ulp\libibnetdisc
Date: Mon, 26 Jul 2010 09:22:30 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A8D7F38F@orsmsx501.amr.corp.intel.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB443B38F543A9@MTLMAIL.mtl.com>
 <3F6F638B8D880340AB536D29CD4C1E1925ABDFF8EF@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1925ABDFF8EF-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Uri Habusha <urih-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: Leonid Keller <leonid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Tzachi Dar <tzachid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Irena Kruchkovsky <irena-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Alex Naslednikov <xalex-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> When compiling the ulp\libibnetdisc  on OFW I got the following casting error. When looking the code
> it really looks problematic. I wonder how you don't see it in your environment.

I just checked, and this error doesn't show up in my build (7600.16385).

> static size_t _unmarshall16(uint8_t * inbuf, uint16_t * num)
> 
> {
> 
>                 (*num) = (uint64_t) inbuf[0];
> 
>                 (*num) |= ((uint16_t) inbuf[1] << 8);

The cast to uint64_t is wrong.  We can replace the above with:

	(*num) = ((uint16_t) inbuf[1] << 8) | inbuf[0];

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
