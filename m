Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06A037207F;
	Wed, 14 Oct 2026 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791989418; cv=none; b=eOqd3MOlc+Sex+kJWFgbT6lrHUSGMG2W0jIQ+XRfi+s+UaJXL9/CTeJHM23J/SrArpd6RRb0/sirwqxSYOp03l25Gn0ysqSMV8weqz1ukr8ZbFXf6qxu1Zr+C9m2LbZWfoDHLZdKUZfePbl8OiEtVSaLeULK1bwpNEMsPKyEPSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791989418; c=relaxed/simple;
	bh=1ZGFJL3aWBxdpm2daJRhOsohwWnF9u/jnnIW8uUSFdI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=XBIeaKuEJ5ed0tp3tPqnmwHoae2MxjP+LJ1lZqf43Y9y0N9GBiUK5+iapYakOZSR9ol1doqJPyQ8euaSj4xZTIKWibL6+RcDiKQY0DldxoA+mjfXERKbj1h/jW2xyip/xdFk4r2iyLviIf8GF5UhHNCNnkwmM+KDKhniyTMY3xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BM+UwMfH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BM+UwMfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E491F000C5;
	Wed, 14 Oct 2026 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791989414;
	bh=NdWDzbW7Y26htAfpjZvTCflFdSCpG0s8lhU2ZneTFLQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=BM+UwMfHAZjW9N+hXqGXqJO9+J70Tu+8At5e5U9AabuLJPkoU+OY5Q1tGeuDSRar7
	 h+ueY9Vo+zchRUUDgnBlJpJjetO+qPXf++oPOSRIyP/PLLyvuOMCgyJOlm++Hbpw60
	 91hK/nZUCLHOb407EzR1u0TPmbD+57P+JLtsy0JLqNWJLg6hPEMYNaJhx/1+SxKz0d
	 SO9dytJU49vKpXLjbMQzrDTGL+wUdcHlbtIZVVNCRud1aDPerhS0f2Ud7adqwIcLSQ
	 +H4U30KC2ow3o0gXS5ee0f1ShRWTDgZpMUZXwUlPNsa0ImzI79zjWNk1pRc+3suPXr
	 gOVfAi3aygJUg==
Received: from stl-compute-04.internal (stl-compute-04.internal [10.204.2.64])
	by mailfauth.stl.internal (Postfix) with ESMTP id 04A4D780043;
	Wed, 14 Oct 2026 10:50:12 -0400 (EDT)
Received: from stl-imap-11 ([10.204.2.102])
  by stl-compute-04.internal (MEProxy); Wed, 14 Oct 2026 10:50:13 -0400
X-ME-Sender: <xms:pJbParDoKmXnnnpeCXDM-T7ZQy3mvEAFl8leKVWTW8fxLoSHruK5UQ>
    <xme:pJbPasUGIp5Y-WerYrbOqfCqOomhS8YNkL3QSuUtKHjrt1PtIhP5Tu_WX_moXYsdi
    sbHexPhmB_BmED0e-qA-2512EZv-PGP1oM7DEoJZYvBXbW1hOGKzMw>
X-ME-Proxy-Cause: dmFkZTEBp4CSFP+oEygyR/ha7jJPYfJMSPM5LgWWD6WbfqNZUsOvuFcngQ6E2/sdCMTQyy
    HijyMuq/lh8owh49Uvpdcd1Ra8UygobWNKOnsEZkYTkmkHBveua5QlCVL0sCLNdxkZT+w3
    DLhzUNIRhU4ZpiQON0x0kMLOeVf1NUWdQo8JyVcvXXYMchFoGUAJI+xNE/ThwwUpa6FP20
    cODEKLQFrG3geSG9+uwSFuaKXh/2ud2Hqj5zJA8H7nV9YIwFspm4XSoh0NWLuXc9SN7nF+
    M0GU0dQmTpL8asKz2BQ4XwgO2/Sbpm/VnJLXVHzZvHTjDZHcObiXGKyIKkXuB2XL3tAzYg
    g5OGTBD8KSmGCXSDu0gnl3UHb3Lp0SpglQkUX+piCkkNEgINFXYTsBjDIeCtd2BdV9QJQ3
    mTfP+iSHHMJzo+KhWjJukhVQ8api1RFiaA7pywTevfwudi7iFEWHwbF3fD5qNbbxrYH6AU
    uYTVm5lCHKo9KUELmKH5bJ67yzCta8QTOKdU30qDP+TjTRIjQ+yKitK4LMuJrfSdbT2I9F
    XD2Zr3H2f1O2VvIbU3//Z6dHBXNQw8Z3KtlE1yB8wGuWJDbUxnRMiVGCy3EYOa2136W6Bm
    7OdRD5lAU7SoYDdBdbK4z9I3J6kegvsNGaHYnREsjFZCq7Mj6bavvPFXsDFw
X-ME-Proxy: <xmx:pJbPansXMvJtbNWVaV-mNd-qlczn-gGt_SH9XPSu00VX_1SCUwMIlg>
    <xmx:pJbPavaCY2nnNd54zW53nb1b3n4NiW-6Jz-Ae3Sgp4IwUoSeeyOUxQ>
    <xmx:pJbPahNykOFC4DtN7tXyMI1gDyWwjUYT8QfRvRRh_Su1dkRJTn2MGA>
    <xmx:pJbPakut9LU5_6VoGmrV77P8-_f8MaRAa1YriFmU-18E2Z6zPqispA>
    <xmx:pJbPapJayEVieuXZFLVJRdxfrNSvTiCPGOlJqmlWP5cgxmEZki4NOH5n>
Feedback-ID: i927946fb:Fastmail
Received: by mailuser.stl.internal (Postfix, from userid 501)
	id 90E9119C0067; Wed, 14 Oct 2026 10:50:12 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 14 Oct 2026 17:49:53 +0300
From: "Leon Romanovsky" <leon@kernel.org>
To: "Bjorn Helgaas" <helgaas@kernel.org>
Cc: "Bjorn Helgaas" <bhelgaas@google.com>,
 "Logan Gunthorpe" <logang@deltatee.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>, "Joerg Roedel" <joro@8bytes.org>,
 "Will Deacon" <will@kernel.org>, "Robin Murphy" <robin.murphy@arm.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, iommu@lists.linux.dev,
 "Tushar Dave" <tdave@nvidia.com>, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
 "Chaitanya Kulkarni" <kch@nvidia.com>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Jens Axboe" <axboe@kernel.dk>, "Alex Williamson" <alex@shazbot.org>,
 "Ankit Agrawal" <ankita@nvidia.com>, "Jonathan Corbet" <corbet@lwn.net>,
 "Shuah Khan" <skhan@linuxfoundation.org>,
 "Randy Dunlap" <rdunlap@infradead.org>,
 "Sumit Semwal" <sumit.semwal@linaro.org>
Message-Id: <eb8e0edd-4c4d-402e-9875-bdbc6d191edf@app.fastmail.com>
In-Reply-To: <20261014132353.GA1625948@bhelgaas>
References: <20261014132353.GA1625948@bhelgaas>
Subject: Re: [PATCH v11 00/19] PCI/P2PDMA: Route peer-to-peer DMA by TLP class
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, Oct 14, 2026, at 16:23, Bjorn Helgaas wrote:
> On Wed, Oct 14, 2026 at 09:53:47AM +0300, Leon Romanovsky wrote:
>> On Tue, Oct 13, 2026 at 05:25:08PM +0300, Leon Romanovsky wrote:
>> > PCI P2PDMA applies Request and Completion Redirect throughout both paths.
>> > This misclassifies asymmetric and nested switches, and reports one answer
>> > for every kind of TLP.
>> > 
>> > Three ACS controls act on TLP attributes the Requester chooses rather
>> > than on the topology: Translation Blocking and Direct Translated P2P act on
>> > a Request's Address Type, and Completion Redirect skips Completions carrying
>> > Relaxed Ordering.
>> > 
>> > Evaluate each direction at the path divergence, decide every class from the
>> > one walk, and treat a client with ATS enabled as translating unless its
>> > driver declares per-mapping ATS.
>> > 
>> > This completes the P2PDMA side; dma-buf and mlx5 follow separately.
>> > 
>> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> > ---
>> > Changes in v11:
>> 
>> 
>> Bjorn,
>> 
>> Could you please save me from the AI-bot attack? Every rebase seems to
>> uncover another bizarre pre-existing issue. It never ends.
>
> Can you elaborate?  I'm not sure what you'd like me to do here.  I
> don't control the Sashiko reviews, and I thought Sashiko was recently
> changed to put pre-existing issues in a database but not in the email
> responses.

AI reviews are not deterministic and every resubmission gives us slightly different result, which is in this phase of submission is  full of hallucinated flows not applicable to the upstream.

In addition to upstream Sashiko, i run everything through local one with slightly better models which hallucinating even more.

I would ask you to merge the series so it gets real exposure in addition to my kunit and specific hw setup.

Thanks 

>
> Bjorn
