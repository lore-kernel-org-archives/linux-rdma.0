From: Uri Habusha <urih-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: error when compiling ofed ulp\libibnetdisc
Date: Mon, 26 Jul 2010 21:31:19 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443B38FD806D@MTLMAIL.mtl.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB443B38F543A9@MTLMAIL.mtl.com>
	<3F6F638B8D880340AB536D29CD4C1E1925ABDFF8EF@orsmsx501.amr.corp.intel.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A8D7F38F@orsmsx501.amr.corp.intel.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443B38FD8063@MTLMAIL.mtl.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A8D7F5BF@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A8D7F5BF-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: Leonid Keller <leonid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Tzachi Dar <tzachid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Irena Kruchkovsky <irena-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Alex Naslednikov <xalex-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I guess we use same WDK version, 6001.10081. That means same compiler.

In any case can you check-in the fix?

-----Original Message-----
From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Monday, July 26, 2010 9:29 PM
To: Uri Habusha; Smith, Stan; ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: Leonid Keller; Tzachi Dar; Irena Kruchkovsky; Alex Naslednikov; Sasha Khapyorsky; Ira Weiny; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: error when compiling ofed ulp\libibnetdisc

> The fix is okay. However I wonder how you don't get the error in your environment and we got it. Any
> idea?

The cast is from an 8-bit value to 64-bit, then back to 16-bit, so there's no chance of losing data with the cast.  Maybe the compiler got smarter?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
