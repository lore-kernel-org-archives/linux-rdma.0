From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: umad_register_oui
Date: Sun, 4 Apr 2010 13:17:22 +0300
Message-ID: <20100404101722.GO4808@me>
References: <3F5FB92A829547AF927C59B5649489B9@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F5FB92A829547AF927C59B5649489B9-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

On 13:00 Fri 26 Mar     , Sean Hefty wrote:
> 
> We hit a bug in our windows implementation of libibumad that highlights an issue
> with the umad interface.  umad_register_oui does not take the mgmt_class as
> input, where umad_register does.  umad_register_oui assumes that the
> mgmt_version is 1.  Not sure if or how you want to handle this.

Basically we could add another call umad_register_oui2() or so with all
needed parameters.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
