Return-Path: <SRS0=3BW3=YQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F195CA9EBD
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE58221D71
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="Epkpchp1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405863AbfJWV4D (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:03 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8185 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392042AbfJWV4D (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 23 Oct 2019 17:56:03 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5db0cc7b0000>; Wed, 23 Oct 2019 14:56:11 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 23 Oct 2019 14:56:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 23 Oct 2019 14:56:02 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 23 Oct
 2019 21:56:02 +0000
Received: from rcampbell-dev.nvidia.com (172.20.13.39) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 23 Oct 2019 21:55:57 +0000
Subject: Re: [PATCH v3 3/3] mm/hmm/test: add self tests for HMM
To:     Jerome Glisse <jglisse@redhat.com>
CC:     John Hubbard <jhubbard@nvidia.com>, Christoph Hellwig <hch@lst.de>,
        "Jason Gunthorpe" <jgg@mellanox.com>, <linux-rdma@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20191023195515.13168-1-rcampbell@nvidia.com>
 <20191023195515.13168-4-rcampbell@nvidia.com>
 <20191023202817.GC3200@redhat.com>
X-Nvconfidentiality: public
From:   Ralph Campbell <rcampbell@nvidia.com>
Message-ID: <9d8a5c65-eba5-48cb-4e48-1163e801c38b@nvidia.com>
Date:   Wed, 23 Oct 2019 14:55:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191023202817.GC3200@redhat.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1571867771; bh=uhUPR74SLBKHNYZZ0/ciaz/geq1b56NM4Hj6Qdao57I=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Epkpchp1EMKIQKPtEGP++Fb+XhcTw/tQvH5ZcnGfWb7ubf88T517sUhEFlalQP1OB
         i/r3Ah/XR725IyEEwJIBlg8eun4vJkGSnDfMRGAoFKpD9YbDg6aj8oRzh4UrLayUsf
         BvVD1h6gfjNXtVSBHJzvS4h9Dt15dT6G9hjLvHvaenMMJJb8GbCyw9lKWFXzJkba1k
         N/qPLIKG0gOgrPTc7mn2QtKJ2o7Ne5AlfXVlIhhso/oShzoweQSosuDgLnvhUvv75E
         VShFxoY7aDJ/GF2Zh+SCQBpZv5iG2cVPtOH/S6f001TUPae4pzKAdKEnfXHpRE061U
         hxstGufTFO68w==
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On 10/23/19 1:28 PM, Jerome Glisse wrote:
> On Wed, Oct 23, 2019 at 12:55:15PM -0700, Ralph Campbell wrote:
>> Add self tests for HMM.
>>
>> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
>=20
> You can add my signoff
>=20
> Signed-off-by: J=E9r=F4me Glisse <jglisse@redhat.com>

Thanks!
