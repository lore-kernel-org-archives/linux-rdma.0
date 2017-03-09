From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH rfc 07/10] nvme-rdma: Don't rearm the CQ when polling
 directly
Date: Thu, 9 Mar 2017 14:52:20 +0100
Message-ID: <1999891a-f19a-f705-705c-98afed65497b@suse.de>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
 <1489065402-14757-8-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1489065402-14757-8-git-send-email-sagi@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 03/09/2017 02:16 PM, Sagi Grimberg wrote:
> We don't need it as the core polling context will take
> are of rearming the completion queue.
 ^ care?

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
