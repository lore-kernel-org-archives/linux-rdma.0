From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4] opensm: Multicast root switch calculation
Date: Thu, 4 Feb 2010 20:52:17 +0200
Message-ID: <20100204185217.GG26338@me>
References: <4B17C712.9010109@Voltaire.COM>
 <20100120102703.GB25576@me>
 <39C75744D164D948A170E9792AF8E7CA01F6FA8A@exil.voltaire.com>
 <20100120115936.GC25576@me>
 <20100127104503.GM26338@me>
 <f0e08f231001280739m31dae78cj5ab7bd78621dcbfc@mail.gmail.com>
 <20100203103428.GW26338@me>
 <20100203103939.GX26338@me>
 <f0e08f231002040622l32c2fc9blc41318828f01cf35@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f231002040622l32c2fc9blc41318828f01cf35-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09:22 Thu 04 Feb     , Hal Rosenstock wrote:
> 
> What about well known groups with no current members ? Do those groups
> not get here or do they have a port ?

Empty MC groups don't participate in routing.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
