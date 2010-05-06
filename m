From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] management: adding mad_dump_fields to libibmad
Date: Thu, 6 May 2010 16:19:53 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A4740D27@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A4740CD8@MNEXMB1.qlogic.org>
	<20100506210248.GG7099@me.iol.unh.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <20100506210248.GG7099-o14lFNPAa+WKTadZzrrH2Q@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha, thanks for sending me that. 

Despite asking several times over the past couple of years, you're the first person to actually point me to a document on how to submit patches to the group.

I will be sure to adhere to that format in the future.

-----Original Message-----
From: Sasha Khapyorsky [mailto:sashakvolt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] On Behalf Of Sasha Khapyorsky
Sent: Thursday, May 06, 2010 5:03 PM
To: Mike Heinz
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
Subject: Re: [PATCH] management: adding mad_dump_fields to libibmad

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
