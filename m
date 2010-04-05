From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: umad_register_oui
Date: Sun, 4 Apr 2010 18:05:38 -0700
Message-ID: <14FF040973DD4244AAD62E2FCB4A4C3A@amr.corp.intel.com>
References: <3F5FB92A829547AF927C59B5649489B9@amr.corp.intel.com> <20100404101722.GO4808@me>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100404101722.GO4808@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Basically we could add another call umad_register_oui2() or so with all
>needed parameters.

In that case, we can probably delay adding the call until it's actually needed.

I only hit the issue because I implemented umad_register to call
umad_register_oui.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
