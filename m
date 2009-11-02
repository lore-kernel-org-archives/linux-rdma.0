From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] opensm: Return single PathRecord for SubnAdmGet
 with DGID/SGID wild carded
Date: Mon, 2 Nov 2009 18:37:27 +0200
Message-ID: <20091102163727.GI21323@me>
References: <1256902806-12040-1-git-send-email-elid@voltaire.com>
 <20091102150308.GB21323@me>
 <4AEF01CE.3040809@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AEF01CE.3040809-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: elid <elid-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: Eli Dorfman <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 17:59 Mon 02 Nov     , elid wrote:
> Return single PathRecord for SubnAdmGet with DGID/SGID wildcarded
> 
> Instead of iterating over all ports in the fabric and returning an error (TOO_MANY_RECORDS),
> when SGID and/or DGID are wild carded return only single PathRecord.
> 
> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
