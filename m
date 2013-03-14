From: "Hudzia, Benoit" <benoit.hudzia-y6kNeMnOB+c@public.gmane.org>
Subject: RE: mlx4 module loading fail
Date: Thu, 14 Mar 2013 22:53:59 +0000
Message-ID: <96353B6F8A3DAE4BBC51047BD0E6BAC2094AD2@DEWDFEMB17A.global.corp.sap>
References: <96353B6F8A3DAE4BBC51047BD0E6BAC20913A5@DEWDFEMB17A.global.corp.sap>
	<5138B372.4020201@mellanox.com>
	<96353B6F8A3DAE4BBC51047BD0E6BAC20914D9@DEWDFEMB17A.global.corp.sap>
 <CAJZOPZKyZgpf3dqfif3c6WHWhriWic06xsWCkdo2TCars3Aehw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKyZgpf3dqfif3c6WHWhriWic06xsWCkdo2TCars3Aehw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi upgrading to 3.9 rc2 fix the issue.

Also  3.2 kernel and under  doesn't cause any error 

> -----Original Message-----
> From: Or Gerlitz [mailto:or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: 08 March 2013 13:33
> To: Hudzia, Benoit
> Cc: Or Gerlitz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Jack Morgenstein
> Subject: Re: mlx4 module loading fail
> 
> On Thu, Mar 7, 2013 at 6:06 PM, Hudzia, Benoit <benoit.hudzia-y6kNeMnOB+c@public.gmane.org>
> wrote:
> >
> > However I did a quick test and by removing physically HALF the ram of the
> server ( basically moving from 1TB to 512GB) everything works fine..
> 
> 
> 
> Yep, you probably hit the problem fixed by commit "mlx4_core: Allow
> large mlx4_buddy bitmaps" 89dd86db78e08b51bab29e168fd41b2fd943e6b6,
> updating your kernel should get that from your way.
> 
> Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
