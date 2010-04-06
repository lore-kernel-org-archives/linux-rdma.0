From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: umad_register_oui
Date: Tue, 6 Apr 2010 11:37:50 +0300
Message-ID: <20100406083750.GS4808@me>
References: <3F5FB92A829547AF927C59B5649489B9@amr.corp.intel.com>
 <20100404101722.GO4808@me>
 <14FF040973DD4244AAD62E2FCB4A4C3A@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <14FF040973DD4244AAD62E2FCB4A4C3A-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 18:05 Sun 04 Apr     , Sean Hefty wrote:
> >Basically we could add another call umad_register_oui2() or so with all
> >needed parameters.
> 
> In that case, we can probably delay adding the call until it's actually needed.
> 
> I only hit the issue because I implemented umad_register to call
> umad_register_oui.

Ok, I see.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
