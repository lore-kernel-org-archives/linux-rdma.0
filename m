Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC152DC783
	for <linux-rdma@vger.kernel.org>; Fri, 28 Aug 2026 09:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787908970; cv=none; b=oLOVXk+qlpKtoZTJ4iO0lSseDOMM/QUVuTj9eWDYQH6FstPvMcyioNcnzweILEtvAG51zuLLzW/H7ERnuKrKGbc1qS1gwFPtixsVp1Rmn58p9yQdSSKqd58P/47cCdWi0it5xvemWXRjD3WwP5kGUsy/Xfz6rWKHxI8wtNBChV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787908970; c=relaxed/simple;
	bh=en6lDMvt8JFBllrn7r9KNDg8ZvcwzB+OR17BzZwxjOw=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=ho/lfElBBNJSq+lRm3nT0wUra74gbXi9EQ3IoJrcCTNamKENEzHVR9IQqJdnJfFOz0JLXGfW/QGeL/TEnSTkYnKUyPNIyE/sVG8AEakOZeKSfOgogf3Rev60PuUsfwDUxKmYRuTGN6HKvvpoDo/LSBbllGdBxocwNT8bWbIPDxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2GsGCIl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2GsGCIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57561F00A3D;
	Fri, 28 Aug 2026 09:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787908969;
	bh=TXsN7t85EQh9DbYY4Dvr8QpGb2jMshb+emvptP30IO0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=D2GsGCIlm9CZevlE5mEeY8mtru5ip2MGWu49+Hs+IixxbSzegOsSDfZ+hdLR9XutT
	 TZqtQIGR/WX7yVacQxGB6Lmj0LFOlOFhjGzy65uqdfqYTv7D9COljrdVpsFNzKYfXH
	 AtiwVmtYl4SaYRQf+ti26yk8C2XoQy84eH/TOMUQj5sjW7f+a6gTVxdG+5m5XbKlx7
	 DKoTV4usFsi9KH8/eMzdra6NSghpitHW8B2xdGoA2VQkpu6ngIvDwaUcDN5iMgDXqo
	 vjQl3XB0lhCOq+nWe8BfFSiFfz/IwO0KqS9igKgDRsKc+jd5z9hxlmLEHEgfwzFkx6
	 v3wAv3Kzw7oOg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 939F5F40066;
	Fri, 28 Aug 2026 05:22:47 -0400 (EDT)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-04.internal (MEProxy); Fri, 28 Aug 2026 05:22:47 -0400
X-ME-Sender: <xms:Z1ORai4Ef6U3UZUfMkeP4k0KwuwQA0oc5jO-MtIkEWEJ0c1nYivhsg>
    <xme:Z1ORamvvzC7OmY-qGV6DL656b69A0NQoF-VEDB0LVl-w7DX_HzolteED1NmL46sW4
    p_ufcbr_CdtOVHCzcX4S9iQVeIA4tiFCUrCbzS1Qi2H57vLAbx262BD>
X-ME-Proxy-Cause: dmFkZTE0Ut545sXRdAJYqyCm5LhWKi17AVJGxAe8/4Xbd9c2AlY4x7aXlpOQvYainGz8ps
    KO0n79yO2AlOubqGgKwEOmXhWwTqg7niYTlPeFnzArzDnJkVtX5+q/uFOin7D7hWZCO5gY
    cW+0VBw+WkfWZwyPaIts1s7W7t+jRjPtCVWdVbAYydl4PNy+sxS4TS0e6LeDN29T7E2ibY
    c/uu5BoMOcfAYvBnJJSb73cLvTNf3VSIHDV6zymW+SUZn5BpmJgS/u+HI79qG//Qcjq4km
    9q1+UJFIWgo3O+6xguj48fWal8ZOe68ZHjPw8iHVqMEVISA85Gkn30YULjn1a8Ri1KIal+
    qAzEhMks3wR3WuOJYeRfhWR4YAxrKiA53UT93fs0Nr61NybA4JbLaZ3PqkVZ8kSJl1MiLP
    p+PcowGRHYeu3Iw3zQwU0BG8+olaynJWNNE2ufBcBIg0BEboBoArdENaP9Au+oind8EHe4
    H0TXTPZFQkFQTakA+rg5IMLcvtRgCpKjDJe+jUKbw4IDmk9qHIxF7RNJjjU0+RUynLxb+4
    NwJUSj/VGy7S4YZg23VX2i3tPtRjtdDwFxZJUwR5dmxrUQAuP3KAEL15MgmMRHB8lvrBcC
    bztXrEfGtpIKOAlRt8D4Q36x074d1c1SytIyVewSv/oT+JfjmIL2YcC32esA
X-ME-Proxy: <xmx:Z1ORaqUIFDDyWOsUTqDhFCFiO9DO-YRZpiie1EZJaeEkfa7YUEPmqA>
    <xmx:Z1ORat05301bWMAIxftZ2HEXP-eeGT8vjVJEaLuyT2m89UdTkuchDQ>
    <xmx:Z1ORapR4ROQm41ULRVkpNtIuxymXpIaH8E5j3BXBJoxMDVBlrlI7Lg>
    <xmx:Z1ORahTXVlVMz_nAmHrURr4aPt88Ssy1RbEd8kCkjZCiuCsb9mY6KA>
    <xmx:Z1ORaqXKw5fZE-r4fLWTHyTbqFDRDZ36P5W4ohwPhFRML_J9xv0JrdaX>
Feedback-ID: i927946fb:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 6E068C40072; Fri, 28 Aug 2026 05:22:47 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 28 Aug 2026 12:22:26 +0300
From: "Leon Romanovsky" <leon@kernel.org>
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>
Cc: brett.creeley@amd.com, "Andrew Lunn" <andrew+netdev@lunn.ch>,
 "David Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>,
 "Paolo Abeni" <pabeni@redhat.com>, allen.hubbe@amd.com,
 nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Jakub Kicinski" <kuba@kernel.org>
Message-Id: <4b766824-5d60-4298-89c8-8d48c6f52827@app.fastmail.com>
In-Reply-To: <a9a9d118-fe06-654c-68a2-75d6c1ce875a@amd.com>
References: <20260813104954.319065-1-abhijit.gangurde@amd.com>
 <20260814102413.5a26bf8b@kernel.org>
 <c565fa0c-08e7-60b9-90e9-07daa4777a48@amd.com>
 <20260820130817.43317368@kernel.org>
 <a9a9d118-fe06-654c-68a2-75d6c1ce875a@amd.com>
Subject: Re: [for-next v6 0/2] Add Reorder Completion Queue (RCQ) support
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Fri, Aug 28, 2026, at 12:02, Abhijit Gangurde wrote:
> On 8/21/26 01:38, Jakub Kicinski wrote:
>> On Mon, 17 Aug 2026 12:35:52 +0530 Abhijit Gangurde wrote:
>>> On 8/14/26 22:54, Jakub Kicinski wrote:
>>>> On Thu, 13 Aug 2026 16:19:52 +0530 Abhijit Gangurde wrote:
>>>>> Patch 1 extends the net/ionic firmware identity structure to expos=
e the
>>>>> rcq_sign_bit field from the RDMA LIF identity.
>>>> I asked for a PR, based on a tag from Linus's tree with that patch.
>>>> Did you send that?
>>>>
>>>> I only see a PR for rdma-core here
>>> Hi Jakub,
>>>
>>> I have the PR ready on Linus's v7.2 tag.
>>>
>>> The following changes since commit 8d3ae59288f1e7d58d76558a6ee96d533=
bc5019f:
>>>
>>>   =C2=A0 Linux 7.2 (2026-08-16 14:32:26 -0700)
>>>
>>> are available in the Git repository at:
>>>
>>>   =C2=A0 https://github.com/abhijitG-xlnx/linux.git ionic_rcq_shared
>>>
>>> for you to fetch changes up to bb23acfd05f0399f33dae000df2ef4a88787b=
7d0:
>>>
>>>   =C2=A0 net: ionic: Fetch RCQ sign bit from firmware (2026-08-17 10=
:58:31 +0530)
>> Thanks! Pulled
>>
>>
> Hi Jason/Leon,
>
> Can RDMA patches also be merged?

We are in merge window now and don't take any next material during that =
period.

Thanks=20

>
> Abhijit
