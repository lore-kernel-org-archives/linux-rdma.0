From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Mellanox target workaround in SRP
Date: Mon, 10 Jan 2011 10:21:07 -0800
Message-ID: <4D2B4E13.6070903@mellanox.com>
References: <1294439717.6219.54.camel@lap75545.ornl.gov><adaipy09h0i.fsf@cisco.com>
	<1294510396.7914.82.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <1294510396.7914.82.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, Ishai Rabinovitz <ishai-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



David Dillow wrote:
> On Fri, 2011-01-07 at 20:05 -0800, Roland Dreier wrote:
>> > I'm sure this was tested and shown to fix the problem; I'm just confused
>>  > as to what the problem really was and if this is still relevant. Can
>>  > someone please enlighten me?
>>
>> At this point I'm afraid it's all lost in the mists of time,
> 
> Yep, that's my fear. And since it is a corruption bug, I've got to tread
> lightly in this area. :/
>

I don't recall to discuss or review this patch with Michael Tsirkin when he summited the patch.


>> looking at the patch, I would guess that the corruption occurred when
>> the target got an IO request that started at a non-page-aligned address
>> but that spanned more than one page.
> 
> That's my thought as well, but then I'm not sure this really solved
> their problem. It may be more likely to occur in the FMR case, but the
> initiator enables clustering, so blk_rq_map_sg() could generate the same
> kinds of requests for both direct and indirect descriptors, even without
> FMR. This looks to have been true since the initiator was added to the
> kernel, though it is possible I'm misreading the code.
> 
>> I don't know if the target was ever fixed, or whether that target code
>> has any relevance today.
> 
> Here's hoping someone from Mellanox can shed some light.


I think that the patch is specific for srp initiator using Mellanox FMR. It tried to avoid indirect desc with Mellanox FMR having first-byte-offset != 0.
Since the low level implementation of mlx4/mthca_map_phys_fmr() did not create + setup MPT for FMR with first_byte_offset != 0. The corruption can happen with any target.

-vu
