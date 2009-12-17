From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Announce] rxe dev tree available (soft RDMAoE)
Date: Wed, 16 Dec 2009 17:32:40 -0800
Message-ID: <alpine.LFD.1.10.0912161731330.11413@topaz.mv.qlogic.com>
References: <4B294BDD.3010405@systemfabricworks.com> <20091216213816.GV6188@obsidianresearch.com> <031b01ca7e99$38abf510$aa03df30$@com> <7FFE592E129646A2B0DB5AC99D0261C7@amr.corp.intel.com> <adafx7a79xh.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adafx7a79xh.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Robert Pearson' <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'frank zago' <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'John Groves' <john-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 16 Dec 2009, Roland Dreier wrote:

| 
|  > Is there any commonality that can be shared between rxe and the qlogic driver?
| 
| Interesting to note that according to ohcount, rxe is 9591 non-blank
| non-comment lines of kernel code, while qib is 36957 lines.  So the
| complexity of IB transport is a small part of the complexity of qib.

Yep.  And a good chunk of the complexity of the qib driver (and ipath
before it) was in dealing with the serdes and it's related issues
(no firmware on the chip to do it, so it's all done in the driver.).

Dave Olson
dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
