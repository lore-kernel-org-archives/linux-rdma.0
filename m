From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/5] Documentation: update stable doc about ABI
 reference generation
Date: Wed, 15 Nov 2017 18:26:12 +0100
Message-ID: <d5cec042-4d26-28e3-6b10-3d15dbfc6d83@suse.de>
References: <8306e0d4-3f4f-1d06-74e1-c971fc63f7b8@suse.de>
 <4bbfedda-eab7-0320-2a37-e3ecbf1093dc@suse.de>
 <20171115055354.GQ18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115055354.GQ18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 15/11/2017 à 06:53, Leon Romanovsky a écrit :
> On Tue, Nov 14, 2017 at 07:58:12PM +0100, Nicolas Morey-Chaisemartin wrote:
>> Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
>> ---
>>  Documentation/stable.md | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/Documentation/stable.md b/Documentation/stable.md
>> index d7ea9822..b7d26c98 100644
>> --- a/Documentation/stable.md
>> +++ b/Documentation/stable.md
>> @@ -63,3 +63,20 @@ Note that for Option 3, if the patch deviates from the original upstream patch (
>>  ## Versioning
>>
>>  See versioning.md for setting package version on a stable branch.
>> +
>> +
>> +## Creating a stable branch
>> +
>> +Stable branch should be created from a release tag of the master branch.
>> +The first thing to do on a master branch is to commit the mainstream release ABI infos
>> +so that latters patches/fixes can be checked against this reference.
> Does it mean that you should rebase your stable-v15 branch?
> It doesn't contain ABI infos yet.

I checked that the current stable-v15 passes the travis-checkabi manually (by generating the ABI from the v15 tag).
So no need there.
Once this series is accepted, I'll backport it to stable-v15 and generate a clean ABI ref from the v15 tag (and commit it)

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
