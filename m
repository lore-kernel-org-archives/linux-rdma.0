From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: Proposal for adding ib_usa to the Linux Infiniband Subsystem
Date: Fri, 21 May 2010 13:19:47 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D193@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D12E@MNEXMB1.qlogic.org>
 <C14850BAABFD4BE789736D497B1DC825@amr.corp.intel.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB49A488D170@MNEXMB1.qlogic.org>
 <20100521165018.GA8856@obsidianresearch.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB49A488D181@MNEXMB1.qlogic.org>
 <20100521172026.GW15969@obsidianresearch.com>
 <9EAF4B21EF0A4B0AB50AF7790DE2C046@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9EAF4B21EF0A4B0AB50AF7790DE2C046-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> IMO, someone needs to propose a specific user space API that provides this
> capability.  Personally, I don't think MADs provide the desired interface.

Agreed. I also agree with Jason that the proliferation of interfaces and modules is an impediment to IB adoption.

And if we need to get the API nailed down first, so be it, that's why I made the proposal the way I did - to get feedback on what was needed.

Let me spend a few days reviewing libibumad and libibverbs, see if can get an idea of what would be the better fit.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
