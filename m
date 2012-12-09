From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] Avoid linker error with clang 3.0
Date: Sun, 9 Dec 2012 11:06:03 -0800
Message-ID: <CAGH67wS1P43ssD+-VFyCupLw3CT8U73wT-aT6N2AS5ddWApAoA@mail.gmail.com>
References: <alpine.BSF.2.00.1212090306300.64779@toaster.local>
	<50C490D9.1000301@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50C490D9.1000301-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 9, 2012 at 5:23 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> On 12/09/12 12:07, Garrett Cooper wrote:
>> It seems that there's a bug when linking inlined functions with clang; this
>> issue will need to be upstreamed and reverified with clang 3.2.
>>
>> Signed-off-by: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>   osmtest/osmtest.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/osmtest/osmtest.c b/osmtest/osmtest.c
>> index 68b0e40..4f56106 100644
>> --- a/osmtest/osmtest.c
>> +++ b/osmtest/osmtest.c
>> @@ -3068,7 +3068,7 @@ Exit:
>>       return (status);
>>   }
>>
>> -inline uint32_t osmtest_path_rec_key_get(IN const ib_path_rec_t * const p_rec)
>> +static uint32_t osmtest_path_rec_key_get(IN const ib_path_rec_t * const p_rec)
>>   {
>>       return (p_rec->dlid << 16 | p_rec->slid);
>>   }
>
> Why was the "inline" keyword dropped ? You didn't explain that in the patch description.

    "inline" was replaced with "static". Reason being (again, although
I didn't explain in complete detail -- sorry, it was late when I sent
out the patch) is that there's a compiler/linker bug in clang where it
appears to optimize out the function improperly on 3.0 at least, but
not fully because it ends up confusing the linker. So I've sidestepped
the issue by making the function static (so it could be better
optimized by the compiler) instead of inlined. An example is provided
below.
Thanks,
-Garrett

# cat /etc/redhat-release
Fedora release 17 (Beefy Miracle)
# uname -a
Linux fallout-fedora.local 3.6.9-2.fc17.i686 #1 SMP Tue Dec 4 14:22:00
UTC 2012 i686 i686 i386 GNU/Linux
# clang --version
clang version 3.0 (tags/RELEASE_30/final)
Target: i386-redhat-linux-gnu
Thread model: posix
# env CC=clang CXX=clang++ CFLAGS="-Werror
-I/nfs/bayonetta/scratch/git/ofed/bin/include"
LDFLAGS="-L/nfs/bayonetta/scratch/git/ofed/bin/lib" ./configure
--prefix=$PWD/../bin
...
# make clean
...
# make all
...
Making all in osmtest
make[1]: Entering directory `/nfs/bayonetta/scratch/git/ofed/opensm/osmtest'
clang -DHAVE_CONFIG_H -I. -I../include -I../include/opensm -I./include
-I./../include -I./../../libibumad/include
-I/nfs/bayonetta/scratch/git/ofed/opensm/../bin/include   -Wall -g
-Werror -I/nfs/bayonetta/scratch/git/ofed/bin/include -MT
osmtest-main.o -MD -MP -MF .deps/osmtest-main.Tpo -c -o osmtest-main.o
`test -f 'main.c' || echo './'`main.c
mv -f .deps/osmtest-main.Tpo .deps/osmtest-main.Po
clang -DHAVE_CONFIG_H -I. -I../include -I../include/opensm -I./include
-I./../include -I./../../libibumad/include
-I/nfs/bayonetta/scratch/git/ofed/opensm/../bin/include   -Wall -g
-Werror -I/nfs/bayonetta/scratch/git/ofed/bin/include -MT
osmtest-osmtest.o -MD -MP -MF .deps/osmtest-osmtest.Tpo -c -o
osmtest-osmtest.o `test -f 'osmtest.c' || echo './'`osmtest.c
mv -f .deps/osmtest-osmtest.Tpo .deps/osmtest-osmtest.Po
clang -DHAVE_CONFIG_H -I. -I../include -I../include/opensm -I./include
-I./../include -I./../../libibumad/include
-I/nfs/bayonetta/scratch/git/ofed/opensm/../bin/include   -Wall -g
-Werror -I/nfs/bayonetta/scratch/git/ofed/bin/include -MT
osmtest-osmt_service.o -MD -MP -MF .deps/osmtest-osmt_service.Tpo -c
-o osmtest-osmt_service.o `test -f 'osmt_service.c' || echo
'./'`osmt_service.c
mv -f .deps/osmtest-osmt_service.Tpo .deps/osmtest-osmt_service.Po
clang -DHAVE_CONFIG_H -I. -I../include -I../include/opensm -I./include
-I./../include -I./../../libibumad/include
-I/nfs/bayonetta/scratch/git/ofed/opensm/../bin/include   -Wall -g
-Werror -I/nfs/bayonetta/scratch/git/ofed/bin/include -MT
osmtest-osmt_slvl_vl_arb.o -MD -MP -MF
.deps/osmtest-osmt_slvl_vl_arb.Tpo -c -o osmtest-osmt_slvl_vl_arb.o
`test -f 'osmt_slvl_vl_arb.c' || echo './'`osmt_slvl_vl_arb.c
mv -f .deps/osmtest-osmt_slvl_vl_arb.Tpo .deps/osmtest-osmt_slvl_vl_arb.Po
clang -DHAVE_CONFIG_H -I. -I../include -I../include/opensm -I./include
-I./../include -I./../../libibumad/include
-I/nfs/bayonetta/scratch/git/ofed/opensm/../bin/include   -Wall -g
-Werror -I/nfs/bayonetta/scratch/git/ofed/bin/include -MT
osmtest-osmt_multicast.o -MD -MP -MF .deps/osmtest-osmt_multicast.Tpo
-c -o osmtest-osmt_multicast.o `test -f 'osmt_multicast.c' || echo
'./'`osmt_multicast.c
mv -f .deps/osmtest-osmt_multicast.Tpo .deps/osmtest-osmt_multicast.Po
clang -DHAVE_CONFIG_H -I. -I../include -I../include/opensm -I./include
-I./../include -I./../../libibumad/include
-I/nfs/bayonetta/scratch/git/ofed/opensm/../bin/include   -Wall -g
-Werror -I/nfs/bayonetta/scratch/git/ofed/bin/include -MT
osmtest-osmt_inform.o -MD -MP -MF .deps/osmtest-osmt_inform.Tpo -c -o
osmtest-osmt_inform.o `test -f 'osmt_inform.c' || echo
'./'`osmt_inform.c
mv -f .deps/osmtest-osmt_inform.Tpo .deps/osmtest-osmt_inform.Po
/bin/sh ../libtool --tag=CC   --mode=link clang -Wall -g -Werror
-I/nfs/bayonetta/scratch/git/ofed/bin/include
-L/nfs/bayonetta/scratch/git/ofed/bin/lib -o osmtest osmtest-main.o
osmtest-osmtest.o osmtest-osmt_service.o osmtest-osmt_slvl_vl_arb.o
osmtest-osmt_multicast.o osmtest-osmt_inform.o  -L../complib -losmcomp
-L../libvendor -losmvendor -L../opensm -lopensm
-L/nfs/bayonetta/scratch/git/ofed/opensm/osmtest/../../libibumad/.libs
-L/nfs/bayonetta/scratch/git/ofed/opensm/../bin/lib -libumad -libumad
-ldl -lpthread
libtool: link: clang -Wall -g -Werror
-I/nfs/bayonetta/scratch/git/ofed/bin/include -o osmtest
osmtest-main.o osmtest-osmtest.o osmtest-osmt_service.o
osmtest-osmt_slvl_vl_arb.o osmtest-osmt_multicast.o
osmtest-osmt_inform.o  -L/nfs/bayonetta/scratch/git/ofed/bin/lib
-L../complib -L../libvendor
/nfs/bayonetta/scratch/git/ofed/opensm/../bin/lib/libosmvendor.so
/nfs/bayonetta/scratch/git/ofed/opensm/../bin/lib/libosmcomp.so
-L../opensm /nfs/bayonetta/scratch/git/ofed/opensm/../bin/lib/libopensm.so
-L/nfs/bayonetta/scratch/git/ofed/opensm/osmtest/../../libibumad/.libs
-L/nfs/bayonetta/scratch/git/ofed/opensm/../bin/lib -libumad -ldl
-lpthread -Wl,-rpath
-Wl,/nfs/bayonetta/scratch/git/ofed/opensm/../bin/lib -Wl,-rpath
-Wl,/nfs/bayonetta/scratch/git/ofed/opensm/../bin/lib
osmtest-osmtest.o: In function `osmtest_validate_path_rec':
/nfs/bayonetta/scratch/git/ofed/opensm/osmtest/osmtest.c:3930:
undefined reference to `osmtest_path_rec_key_get'
osmtest-osmtest.o: In function `osmtest_parse_path':
/nfs/bayonetta/scratch/git/ofed/opensm/osmtest/osmtest.c:6853:
undefined reference to `osmtest_path_rec_key_get'
clang: error: linker command failed with exit code 1 (use -v to see
invocation) [err_drv_command_failed]
make[1]: *** [osmtest] Error 1
make[1]: Leaving directory `/nfs/bayonetta/scratch/git/ofed/opensm/osmtest'
make: *** [all-recursive] Error 1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
