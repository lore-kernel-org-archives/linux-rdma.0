From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] buildlib: add script to dump ABI
Date: Wed, 15 Nov 2017 18:52:49 +0100
Message-ID: <9f40619b-bd97-ad6f-494b-c493dd3c3c21@suse.de>
References: <8306e0d4-3f4f-1d06-74e1-c971fc63f7b8@suse.de>
 <8bcdf747-5613-8990-5742-8a9b6e552ac9@morey-chaisemartin.com>
 <20171115055632.GR18825@mtr-leonro.local>
 <b36cd702-5d8e-c116-3306-39e1a1b8aaf5@suse.de>
 <20171115173719.GC18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115173719.GC18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 15/11/2017 à 18:37, Leon Romanovsky a écrit :
> On Wed, Nov 15, 2017 at 06:22:33PM +0100, Nicolas Morey-Chaisemartin wrote:
>>
>> Le 15/11/2017 à 06:56, Leon Romanovsky a écrit :
>>> On Tue, Nov 14, 2017 at 07:57:55PM +0100, Nicolas Morey-Chaisemartin wrote:
>>>> Builds rdma-core in -Og/Debug mode and use abi-dumper to generate 1 xml
>>>>  per .so.*.* file.
>>>> Do not use .so file directly. Providers have no symbol exported
>>>>  and cause abi-dumer to exit with an error.
>>> mlx4/mlx5 do export.
>>>
>>> Thanks
>>
>> Yes but they also export versiones .so files
>> $ ll build-abi/lib/libmlx*
>> lrwxrwxrwx 1 nmorey users     17 Nov 14 19:51 build-abi/lib/libmlx4-rdmav16.so -> libmlx4.so.1.0.16
>> lrwxrwxrwx 1 nmorey users     12 Nov 14 19:51 build-abi/lib/libmlx4.so -> libmlx4.so.1
>> lrwxrwxrwx 1 nmorey users     17 Nov 14 19:51 build-abi/lib/libmlx4.so.1 -> libmlx4.so.1.0.16
>> -rwxr-xr-x 1 nmorey users 276600 Nov 14 19:51 build-abi/lib/libmlx4.so.1.0.16
>> lrwxrwxrwx 1 nmorey users     17 Nov 14 19:51 build-abi/lib/libmlx5-rdmav16.so -> libmlx5.so.1.2.16
>> lrwxrwxrwx 1 nmorey users     12 Nov 14 19:51 build-abi/lib/libmlx5.so -> libmlx5.so.1
>> lrwxrwxrwx 1 nmorey users     17 Nov 14 19:51 build-abi/lib/libmlx5.so.1 -> libmlx5.so.1.2.16
>> -rwxr-xr-x 1 nmorey users 690712 Nov 14 19:51 build-abi/lib/libmlx5.so.1.2.16
>>
>> So the .so are ignored (specially the -rdmav16) but the standalone ones aren't
> We are supporting static builds too (*.a and not *.so), can the script
> be extended to check them too?
>
> Thanks

Does that changes something ? As long as the specific build-abi build generates the .so, it should be sufficient to check the ABI.
Wether someone build with static options or not.
Unless there are other static libs I'm missing.

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
