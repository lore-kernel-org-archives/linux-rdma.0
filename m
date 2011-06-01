From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH 1v2] opensm: fixed port order configuration in torus
 routing engine
Date: Wed, 1 Jun 2011 16:30:18 -0600
Message-ID: <4DE6BD7A.9030102@sandia.gov>
References: <20110530132345.GB20342@calypso.voltaire.com>
 <4DE50C21.7020305@sandia.gov>
 <20110601154046.GA1098@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110601154046.GA1098-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Alex Netes wrote:
> Commit 1c2a298b295eba7e24205519abc24e47106d15df broke port order
> configuration for torus routing engine. order was incorrectly initiated,
> causing setting LFTs to fail.
> 
> Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Acked-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>

Also, while reviewing this I noticed a couple things in the
port-order patch that I should have noticed earlier, but
didn't.  I have a couple of minor fixup patches that go on
top of this one, to send along in a minute.

-- Jim

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
