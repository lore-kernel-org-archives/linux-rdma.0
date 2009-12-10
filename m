From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 06/11] RDMA/nes: abnormal listener termination causes
 loopback node crash
Date: Thu, 10 Dec 2009 09:21:11 -0600
Message-ID: <4B2111E7.80607@opengridcomputing.com>
References: <20091209224115.GA128120@flatif-MOBL> <4B20A00C.1070607@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B20A00C.1070607-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Or Gerlitz wrote:
> Faisal Latif wrote:
>> when listener is destroyed for loopback connection
> Does the upstream iwarp stack supports loopback connections? does it 
> apply to all vendors?
>
> Or.

Loopback support is provider-specific.  There is no software iwarp 
loopback, if that's what your asking.  But the upstream core code 
doesn't prohibit providers from supporting hw-loopback connections.


Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
