From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Mon, 24 Jan 2011 17:32:04 +0200
Message-ID: <4D3D9B74.8090607@voltaire.com>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>	<aday66hxxwe.fsf@cisco.com>  <4D3805C4.6010203@voltaire.com> <1295528044.22825.64.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295528044.22825.64.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

David Dillow wrote:
>> if we look on the 50% for SAS/1M IOs that you're presenting, can you tell 
>> what made the difference, srp went from sg_tablesize of 255 to 256 so the 
>> upper layers where able to provide 1M as one IO

> This win is from sg_tablesize going from 255 to 256 in this case; the HW
> really likes that better than getting two requests -- one for 1020 KB
> and one for 4 KB. 

Its always nice to find the simplest explanation to the greatest improvement... going to the 2nd largest gains

> SAS	2M	520 MB/s	861 MB/s
> SAS	4M	529 MB/s	921 MB/s
> SAS	8M	600 MB/s	951 MB/s

I wonder what made the difference here? it can't be only the 255 --> 256 sg_tablesize change, for the 2M case the change to use 512 pages FMRs could let you use one rkey/fmr for the whole IO but not for 4M/8M

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
