From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] opensm - use uintptr_t instead of unsigned long
Date: Thu, 8 Oct 2009 11:55:08 -0600
Message-ID: <20091008175508.GY5191@obsidianresearch.com>
References: <B4D2EF981C584307AA9204669ECE3F31@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <B4D2EF981C584307AA9204669ECE3F31-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 08, 2009 at 10:12:03AM -0700, Stan C. Smith wrote:

> If you can live with uintptr_t for 
>   __WORDSIZE == 32 being 'unsigned int' (see stdint.h)
>   __WORDSIZE == 64 uintptr_t is 'unsigned long int'
> then we could skip the ifdef __GNUC__ and just replace 'unsigned long' with uintptr_t.

uinptr_t is the appropriate ISO C99 type for this, every platform
should use it.

Non-standard names like st_ptr_t should just be eradicated.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
