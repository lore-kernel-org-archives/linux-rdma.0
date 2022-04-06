Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EDEEC433F5
	for <linux-rdma@archiver.kernel.org>; Wed,  6 Apr 2022 17:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239348AbiDFRiy (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239345AbiDFRib (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 6 Apr 2022 13:38:31 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EA03839A2;
        Wed,  6 Apr 2022 08:47:31 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4C5E168AFE; Wed,  6 Apr 2022 17:47:24 +0200 (CEST)
Date:   Wed, 6 Apr 2022 17:47:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        virtualization@lists.linux-foundation.org,
        Will Deacon <will@kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH 1/5] iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY
 with dev_is_dma_coherent()
Message-ID: <20220406154723.GA30153@lst.de>
References: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com> <1-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com> <20220406053039.GA10580@lst.de> <20220406120730.GA2120790@nvidia.com> <20220406135150.GA21532@lst.de> <20220406141446.GE2120790@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406141446.GE2120790@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Apr 06, 2022 at 11:14:46AM -0300, Jason Gunthorpe wrote:
> Really? It is the only condition that dma_info_to_prot() tests to
> decide of IOMMU_CACHE is used or not, so you are saying that there is
> a condition where a device can be attached to an iommu_domain and
> dev_is_dma_coherent() returns the wrong information? How does
> dma-iommu.c safely use it then?

arm does not use dma-iommu.c
