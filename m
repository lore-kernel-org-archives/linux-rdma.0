From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH rfc 01/10] nvme-pci: Split __nvme_process_cq to poll and
 handle
Date: Thu, 9 Mar 2017 14:57:44 +0100
Message-ID: <872aed98-0974-820d-c8fc-0300e40c8fcb@suse.de>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
 <1489065402-14757-2-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1489065402-14757-2-git-send-email-sagi@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 03/09/2017 02:16 PM, Sagi Grimberg wrote:
> Just some rework to split the logic and make it slightly
> more readable. This will help us to easily add the irq-poll
> logic.
> 
> Also, introduce nvme_ring_cq_doorbell helper to mask out the
> cq_vector validity check.
> 
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
