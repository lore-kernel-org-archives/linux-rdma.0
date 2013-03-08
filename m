From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx4 module loading fail
Date: Fri, 8 Mar 2013 15:32:55 +0200
Message-ID: <CAJZOPZKyZgpf3dqfif3c6WHWhriWic06xsWCkdo2TCars3Aehw@mail.gmail.com>
References: <96353B6F8A3DAE4BBC51047BD0E6BAC20913A5@DEWDFEMB17A.global.corp.sap>
	<5138B372.4020201@mellanox.com>
	<96353B6F8A3DAE4BBC51047BD0E6BAC20914D9@DEWDFEMB17A.global.corp.sap>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <96353B6F8A3DAE4BBC51047BD0E6BAC20914D9-v0w1aZ/WxVLTw0Kyn31wWKuC/IaeJB0jHWlK3eZauXw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hudzia, Benoit" <benoit.hudzia-y6kNeMnOB+c@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 7, 2013 at 6:06 PM, Hudzia, Benoit <benoit.hudzia-y6kNeMnOB+c@public.gmane.org> wrote:
>
> However I did a quick test and by removing physically HALF the ram of the server ( basically moving from 1TB to 512GB) everything works fine..



Yep, you probably hit the problem fixed by commit "mlx4_core: Allow
large mlx4_buddy bitmaps" 89dd86db78e08b51bab29e168fd41b2fd943e6b6,
updating your kernel should get that from your way.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
