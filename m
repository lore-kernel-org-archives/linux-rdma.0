From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] buildlib: run ABI check in travis-build
Date: Wed, 15 Nov 2017 18:24:32 +0100
Message-ID: <a6eadf81-1557-bf9c-c163-61461bc5c271@suse.de>
References: <8306e0d4-3f4f-1d06-74e1-c971fc63f7b8@suse.de>
 <866df5d4-2a54-2014-a180-1fd0dc43d0fa@suse.de>
 <20171115055825.GS18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115055825.GS18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 15/11/2017 à 06:58, Leon Romanovsky a écrit :
> On Tue, Nov 14, 2017 at 07:58:06PM +0100, Nicolas Morey-Chaisemartin wrote:
>> Run travis-checkabi during travis build
>>
>> Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
>> Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org # v15
>> ---
>>  buildlib/travis-build | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/buildlib/travis-build b/buildlib/travis-build
>> index bf86baa7..f8e5ee05 100755
>> --- a/buildlib/travis-build
>> +++ b/buildlib/travis-build
>> @@ -5,6 +5,10 @@ set -e
>>  # Echo all commands to Travis log
>>  set -x
>>
>> +
>> +# Build in debug mode and check the ABI against the ref
>> +./buildlib/travis-checkabi
> Will it run for all commits, including master?

Yes and no.
The script is called for all commits. But one of the first thing it does is checking that reference file exists and ignore if they don't (see Patch 3):

+# No reference ABI to match against.
+if [ ! -d $REF_DIR ]; then
+	echo "INFO: Skipping ABI check. No reference available"
+	exit 0
+fi
+

It might be worth doing this test first in the script to avoid the debug build / abi-dumper calls.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
