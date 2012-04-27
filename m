From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 3/5] ib-diags/saquery: Fix smkey handling
Date: Fri, 27 Apr 2012 07:54:39 -0400
Message-ID: <4F9A88FF.4070100@dev.mellanox.co.il>
References: <1335228837.17237.302.camel@auk75.llnl.gov>  <1335229017-10677-1-git-send-email-foraker1@llnl.gov>  <1335229017-10677-3-git-send-email-foraker1@llnl.gov>  <4F96B5F8.8070801@dev.mellanox.co.il>  <1335310971.17237.407.camel@auk75.llnl.gov>  <4F97F4A5.40007@dev.mellanox.co.il>  <1335396262.17237.494.camel@auk75.llnl.gov>  <4F9939B9.8090104@dev.mellanox.co.il> <1335487548.17237.605.camel@auk75.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335487548.17237.605.camel-mxTxeWJot8FliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/26/2012 8:45 PM, Jim Foraker wrote:
> 
> On Thu, 2012-04-26 at 05:04 -0700, Hal Rosenstock wrote:
>> On 4/25/2012 7:24 PM, Jim Foraker wrote:
>>>
>>> On Wed, 2012-04-25 at 05:57 -0700, Hal Rosenstock wrote:
>>>> On 4/24/2012 7:42 PM, Jim Foraker wrote:
>>>>>
>>>>> On Tue, 2012-04-24 at 07:17 -0700, Hal Rosenstock wrote:
>>>>>> On 4/23/2012 8:56 PM, Jim Foraker wrote:
>>>>>>> smkey is already defined as a global inside saquery.c, so remove
>>>>>>> broken support for passing it around as a function parameter
>>>>>>>
>>>>>>> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
>>>>>>> ---
>>>>>>>  src/saquery.c |   59 ++++++++++++++++++++++++++++-----------------------------
>>>>>>>  1 file changed, 29 insertions(+), 30 deletions(-)
>>>>>>>
>>>>>>> diff --git a/src/saquery.c b/src/saquery.c
>>>>>>> index e5fdb25..029228c 100644
>>>>>>> --- a/src/saquery.c
>>>>>>> +++ b/src/saquery.c
>>>>>>> @@ -85,7 +85,7 @@ struct query_cmd {
>>>>>>>  
>>>>>>>  static char *node_name_map_file = NULL;
>>>>>>>  static nn_map_t *node_name_map = NULL;
>>>>>>> -static uint64_t smkey = 1;
>>>>>>> +static uint64_t smkey = 0;
>>>>>>
>>>>>> Why is the default for smkey being changed from 1 to 0 ? Note that even
>>>>>> though the name is smkey (due to the spec), it is really the default SA key.
>>>>>      Previous to the patch, smkey was defined as 1, but rarely passed
>>>>> thru to functions.  In particular, the only SA requests that were using
>>>>> the default value of 1 were MCMember records, via either the -m option
>>>>> or the MCMR query.  All other types were hard coded to smkey values of
>      I need to correct myself.  Looking thru the code again today, I
> realized that I had forgotten that ClassPortInfo calls sa_query
> directly, so it has been using an smkey of 1 as well.
> 
>>>>> 0, and hence executing untrusted SA requests, regardless of either the
>>>>> smkey variable defaulting to 1 or of any "--smkey" being passed on the
>>>>> command line.
>>>>
>>>> In addition to MCMemberRecords, trust is supported for
>>>> P_KeyTableRecords, PortInfoRecords, and ServiceRecords AFAIT. Patch
>>>> shortly for InformInfoRecords and InformInfo.
>>>      Trust may be implemented in OpenSM, but it is not being used by the
>>> diags.  The vast majority of the patch deals with removing the smkey or
>>> trusted parameters to calls to get_{all,any}_records() and
>>> get_and_dump_{all,any}_records().  In almost every one of those cases, a
>>> value of "0" was being passed in the trusted/smkey field, either of
>>> which results in sa_query() being called with the smkey set to 0 --
>>> hence, an untrusted request.
>>>      In addition, get_and_dump_all_records() did not pass the trusted
>>> parameter on when it called get_all_records(), so it _always_ generates
>>> untrusted requests.
>>>
>>>>
>>>>>      Changing the variable default to 0 causes the patch to effect the
>>>>> least change in observable behavior.  
>>>>
>>>> Not sure what you mean by that.
>>>      What I mean is that if we leave smkey at 0 in the patch, the output
>>> that users of saquery will see (without passing a smkey on the command
>>> line) will change very little post-patch -- only MCMember records will
>>> change.
>>>      If we apply the patch but with smkey changed to 1, users will see
>>> far more new behavior.  If the subnet is partitioned, they will see more
>>> results for every record type other than MCMember than they did
>>> previously.  They will also begin to see valid Mkeys, ServiceKeys, and
>>> QPNs in their results.  Conversely, if they have changed their SA smkey
>>> away from 1, they will get no results whatsoever, from any request,
>>> until they pass an smkey on the command line.
>>>
>>>>> In particular, for commands not
>>>>> specifying a smkey on the command line, the visible changes are limited
>>>>> to MCMember records.  For subnets not using partitioning, the change in
>>>>> MCMember records is limited to the specifics for that record type
>>>>> covered in C15-0.2-1.16.
>>>>
>>>> Even without partitioning, this is important for validating all members
>>>> in MC group (for IPoIB debug).
>>>      That information would still be available, it just would require
>>> configuring/passing the right smkey.
>>>
>>>>
>>>> It also affects the previously aforementioned SA records as well.
>>>      It only affects them if the user passes an smkey.  Currently, all
>>> record types other than MCMember are queried for with an smkey of 0,
>>> even if smkey is passed on the command line.  Fixing the handling and
>>> then changing the default to 0 means most SA records are still queried
>>> with an smkey of 0, resulting in identical behavior as before, but now
>>> the user can actually usefully change what smkey is used.
>>>
>>>>
>>>>>      Setting the default to 1 may provide better behavior, in terms of
>>>>> making the diags "just work" for an out-of-the-box OpenSM config, 
>>>>
>>>> Yes, that was the original intention.
>>>>
>>>>> but it
>>>>> seems to me that the continued existence of this bug shows that
>>>>> authenticated requests might not be particularly important for simple
>>>>> configs.  Plus, it extracts a penalty -- post-patch, if the default is
>>>>> set to 1, a user who chooses to change their SA smkey will be penalized
>>>>> in the sense that they will always need to pass an smkey on the command
>>>>> line, either the correct one or "--smkey 0" to execute an untrusted
>>>>> request (packets with incorrect smkeys are dropped, not considered
>>>>> untrusted).  
>>>>
>>>> That is the tradeoff and it was the decision made. I can dig out the
>>>> threads on the list if need be.
>>>>
>>>>> With a default of 0, we are not providing users
>>>>> encouragement to leave their SA smkey (which in turn protects other
>>>>> authentication keys on the fabric) at a well-known, insecure value.
>>>>
>>>> Yes, it comes down ease of use v. "security". Also, changing this now
>>>> becomes a flag day/backward compatibility issue (at least in terms of
>>>> support).
>>>      How does this warrant a flag day?  It's a bug fix to a query
>>> utility, which as currently implemented, preserves most current
>>> behavior, and in the two cases it doesn't, the current behavior can be
>>> recaptured by passing one command line parameter.
>>
>> I was referring to the user/admin expectation of seeing all
>> MCMemberRecords without supplying smkey and now to get that he will need
>> a different command. Changes like these cause confusion (and support).
>>
>> I didn't realize about the other lacking saquery support for trust in
>> the other SA records. That definitely changes the picture.
>>
>> So the question seems to be whether or not to preserve the original user
>> experience in terms of MCMemberRecord behavior and if so, how to
>> accomplish that. I think that might mean an additional policy (like
>> smkey_mcmr).
>      Yes, saquery would need to be aware of two different smkeys -- one
> for the previously-trusted requests, and one for the
> previously-untrusted requests.  There would then need to be some logic
> that works out how passed-in smkeys are used -- do we need to create a
> 2nd command line option plus 2 config file options?  In order to not
> break scripts, do we need to make "--smkey" change only the MCMR and CPI
> keys (as was previously the case) and then have something akin to
> "--smkey_everything_else" (but hopefully better named)?
>      It can all be done, but it exacts a cost in complexity (and hence
> future support/maintenance) that seems hard to justify to me.  I'm just
> not convinced that it will be less confusing for users to deal with
> configuring a split-brained dual-smkey world than it will be to deal
> with what amounts to a fairly minor interface change after explicitly
> upgrading their software.  They can, after all, resurrect the old
> behavior by passing one command line option.

At this point, it's Ira's call.

-- Hal

>      Jim
> 
>>
>> -- Hal
>>
>>>
>>>      Jim
>>>
>>>>
>>>>>      A compromise would be for someone to write a patch that adds
>>>>> support for a default SA smkey to the diags config file.
>>>>
>>>> Makes sense.
>>>>
>>>>> In that case, I think the right behavior would be for the compiled utility to still
>>>>> default to 0 so that saquery works on hosts without an smkey set in the
>>>>> conf (the default config file might set the value to 1), which means
>>>>> this patch as written does not get in the way.
>>>>
>>>> OK but IMO we shouldn't change the smkey value here until this occurs.
>>>>
>>>> -- Hal
>>>>
>>>>>      Jim
>>>>>
>>>>>>
>>>>>> -- Hal
>>>>>>
>>>>>> <snip...>
>>>>>
>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
