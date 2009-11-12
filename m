From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: OpenSM: reporting traps 129, 130, 131
Date: Thu, 12 Nov 2009 22:36:04 +0200
Message-ID: <20091112203604.GS7192@me>
References: <4AF6D78E.6080600@dev.mellanox.co.il>
 <f0e08f230911120546q5aa0ed72oc6811cbd2471bc44@mail.gmail.com>
 <20091112154213.GH7192@me>
 <f0e08f230911120838w2f824a4dnc6b51a68b25bbffd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230911120838w2f824a4dnc6b51a68b25bbffd-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11:38 Thu 12 Nov     , Hal Rosenstock wrote:
> 
> We've cared for several years now (babbling port policy was introduced
> into the master on 7/6/09) but this issue still persists. Are you
> saying no reports for these traps until the trap rate is obeyed ?

If existing trap rate filtering in OpenSM is sufficient we can add
reporting (if somebody needs this). I just don't think that we need to
introduce temporary options.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
