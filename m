From: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH] firmware,IB/qib: revert firmware file move
Date: Fri, 5 Apr 2013 17:52:42 -0000
Message-ID: <3fedc8674945fdc41d17ecddf82a1dba.squirrel@twosheds.infradead.org>
References: <20130405173133.19936.8383.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130405173133.19936.8383.stgit@phlsvslse11.ph.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: roland@purestorage.com, Dean Luick <dean.luick@intel.com>, linux-rdma@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Vinit Abhay Agnihotri <vinit.abhay.agnihotri@intel.com>, linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
List-Id: linux-rdma@vger.kernel.org


> Commit e2eed58 ("IB/qib: change QLogic to Intel") moved a firmware file
> potentially breaking the ABI.
>
> This patch reverts that aspect of the fix as well as reverting the
> firmware name as used in qib.
>
> Reported-by: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>

Thanks. I think there's a one-liner in firmware/Makefile which also needs
to be reverted along with moving the file itself? Other than that,

Acked-by: David Woodhouse <David.Woodhouse@intel.com>

-- 
dwmw2
