From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] management: adding mad_dump_fields to libibmad
Date: Fri, 7 May 2010 00:02:48 +0300
Message-ID: <20100506210248.GG7099@me.iol.unh.edu>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A4740CD8@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A4740CD8-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13:27 Thu 06 May     , Mike Heinz wrote:
> Sasha asked that I re-submit the patches for perfquery in a slightly different format. This is the first of 3 patches.

I just asked to try to follow the normal patch submission format
described in details there:

http://git.kernel.org/?p=linux/kernel/git/roland/infiniband.git;a=blob;f=Documentation/SubmittingPatches

So each patch will have its own subject line, commit message, etc.

> This patch adds a function to libibmad that allows the caller to dump a configurable range of MAD attributes. Basically, this provides an external interface to the internal function _dump_fields.
> 
> Signed Off: Michael Heinz

All three applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
