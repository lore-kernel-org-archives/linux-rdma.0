From: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Subject: Re: trouble sending mail to mailing list
Date: Mon, 6 Sep 2010 12:15:30 -0700
Message-ID: <4C853DD2.9090105@nasa.gov>
References: <AANLkTinp1LPkm5V7U4hfN0m+n_L3O5i_81wy733J+4cK@mail.gmail.com> <E113D394D7C5DB4F8FF691FA7EE9DB443B74E3E362@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB443B74E3E362-WQlSmcKwN8Te+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Jonathan Perkins <perkinjo-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, Dhabaleswar Panda <panda-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, Jeff Callison <jeffc-wiP6UGNpsDaB+jHODAdFcQ@public.gmane.org>, "peeyush-+SHkuY4UpUhWk0Htik3J/w@public.gmane.org" <peeyush-+SHkuY4UpUhWk0Htik3J/w@public.gmane.org>, Paul Owen <paulo-wiP6UGNpsDaB+jHODAdFcQ@public.gmane.org>, 'Bill Boas' <bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "'Ryan, Jim'" <jim.ryan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Tziporet. On Friday, Owen Media (cc'd) cut over to a new server (not
sofa.openfabrics.org - I still don't understand this), and contacted
GoDaddy to move our domain.

> ping openfabrics.org
PING openfabrics.org (198.63.41.212) 56(84) bytes of data.
64 bytes from open11.tempdomainname.com (198.63.41.212): icmp_seq=1
ttl=47 time=99.1 ms
64 bytes from open11.tempdomainname.com (198.63.41.212): icmp_seq=2
ttl=47 time=95.6 ms

So it doesn't seem to be at John Companies any more. I assume the builds
etc., are still happening at John Companies, but I'm not sure.  I'm
pretty sure the domain move is the root of the list problems,

Anyway, Paul, Jeff etc., stuff seems to be broken right now. Please fix.
Thanks.

-jeff

On 09/06/2010 02:47 AM, Tziporet Koren wrote:
> Yes - all OFA web is not working fine
> I will send mails to other people too
>
> Tziporet
>
> -----Original Message-----
> From: Jonathan Perkins [mailto:perkinjo-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org] 
> Sent: Monday, September 06, 2010 7:53 AM
> To: Jeff Becker; Tziporet Koren
> Cc: Dhabaleswar Panda
> Subject: trouble sending mail to mailing list
>
> Hi, I'm not sure if this is just happening to me or not but I'm unable
> to send mail to the ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org or ewg-G2znmakfqn4E3QRLGMYmdQ@public.gmane.org
> I'm getting messages back stating that the servers cannot be found.
> Is this expected with the transitioning of the administration of the
> new servers?  I also cannot log into www.openfabrics.org at this time
> but I just used the ip address of the old server to circumvent this
> issue.
>
> The original message was received at Mon, 6 Sep 2010 00:44:11 -0400 (EDT)
> from mail-vw0-f50.google.com [209.85.212.50]
>
>   ----- The following addresses had permanent fatal errors -----
> <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
>    (reason: 550 Host unknown)
>
>   ----- Transcript of session follows -----
> 550 5.1.2 <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>... Host unknown (Name server:
> lists.openfabrics.org: host not found)
>
> Final-Recipient: RFC822; ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> Action: failed
> Status: 5.1.2
> Remote-MTA: DNS; lists.openfabrics.org
> Diagnostic-Code: SMTP; 550 Host unknown
> Last-Attempt-Date: Mon, 6 Sep 2010 00:44:11 -0400 (EDT)
>
>
> ---------- Forwarded message ----------
> From: Jonathan Perkins <perkinjo-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
> To: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> Date: Mon, 6 Sep 2010 00:44:10 -0400
> Subject: mvapich2 srpm uploaded
> Hi all:
> I've uploaded a pre-release of mvapich2-1.5.1 to the (old) openfabrics
> server at ~perkinjo/ofed_1_5/mvapich2-1.5.1-0.1.20100905svn4167.src.rpm.
>  It's also indicated by the ~perkinjo/ofed_1_5/latest.txt file.  This
> tarball contains bug fixes and several enhancements compared to the
> mvapich2-1.5 release.  Our formal release will follow soon.
>
> FYI, I'm unable to log into the new openfabrics server
> (www.openfabrics.org).  Is it expected to log into 69.55.239.13 using
> its ip address?
>
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
