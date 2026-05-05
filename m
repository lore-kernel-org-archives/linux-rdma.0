Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C471540DFDA;
	Tue,  5 May 2026 00:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777939418; cv=none; b=KqtiqckcIiA9whGhr349N4Wet9VRbtO2iwPpmevWBupJbB8AWZUzYqbVltEpEjR9mcsjojcomMG6KqUKmA/fSC5BYeGNFyDvVFQ7Fd7jaNwvcnC97rL9CR2Q1kFzZykMIp5JsyrQ8/tdswa1S4AI/8Zh2buqcrsVmLyzbrE6H/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777939418; c=relaxed/simple;
	bh=8I/hVAxtgOoP2n2/kmLok5hTmrkCfguXUluau3/Oqr0=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Nnsgvg+OTa5Nm1D8AFkmj0byImAKJ8Ujy9GH49uMD/Ae1siwkZd5mxsfZiakkRAGpFrl7NaGYjGUkPtp1QFAhUxWZcMUoo6HsYaTGohG9ZWz9xhV9IE87GtT78B72qsQP+S1KYb38EteZFP8tg3+s882s+dPxjDF4ZtxxZ37PMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 5196092009C; Tue,  5 May 2026 02:03:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 4A75792009B;
	Tue,  5 May 2026 01:03:34 +0100 (BST)
Date: Tue, 5 May 2026 01:03:34 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Bjorn Helgaas <bhelgaas@google.com>, 
    Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
cc: =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
    linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] PCI+IB/hfi1: Fold duplicate secondary bus reset
 code
Message-ID: <alpine.DEB.2.21.2605050042390.46195@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi,

 This v2 of the patch series addresses a documentation issue raised in v1.

 In the course of verifying my PCIe link training failure workaround (cf. 
<https://lore.kernel.org/r/alpine.DEB.2.21.2305310024400.59226@angie.orcam.me.uk/>) 
in the context of secondary bus reset handling I found a piece of code in 
the InfiniBand HFI1 driver that duplicates what we already have as private 
code in PCI core.  This patch series removes this duplication by exporting 
said private code and than making use of it in the HFI1 driver.

 As I have no means to run-time verify InfiniBand code I have only build 
these patches, for x86-64, with the HFI1 driver both built in and modular.
Please see individual change descriptions for further details.

 Please consider.

 Previous iterations:

- v1 at: <https://lore.kernel.org/r/alpine.DEB.2.21.2306200153110.14084@angie.orcam.me.uk/>.

  Maciej
