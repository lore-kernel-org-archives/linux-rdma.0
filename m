From: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ibsim: fix size of slid/dlid fields in sim_request structure
Date: Wed, 10 Aug 2011 11:18:33 -0600
Message-ID: <4E42BD69.6070608@obsidianresearch.com>
References: <E1QpTpl-00026F-D6@rvml.edm.orcorp.ca> <20110809150723.GC2056@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110809150723.GC2056-iQai9MGU/dze+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Alex,
> There are more places where lids defined as integer. Why did you choose to
> change only these two?

This structure defines what request packets look like on the wire to the 
simulator.
The motivation for the change is a simulator client for python-rdma, and 
this issue
shows up when creating the structure format strings for the request packets.

     Rolf


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
